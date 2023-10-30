library tempo_estimator;

import 'dart:math';

part 'statistics.dart';

/// 99% Confidence Interval
///
/// https://en.wikipedia.org/wiki/Confidence_interval#Basic_steps
const _zStar99Percent = 2.576;

/// Adjacent tap deviations are correlated, so normal confidence interval
/// estimation is actually kind of useless. This adjustment doesn't mean much,
/// but it works roughly right in practice.
const _confidenceIntervalScale = 2.0;

/// Calculates a 99% confidence interval.
class TempoEstimator {
  TempoEstimator({Duration resetTimeout = const Duration(seconds: 5)})
      : _resetTimeout = resetTimeout;

  final Duration _resetTimeout;
  DateTime? _lastBeat;
  List<Duration> _beatDurations = [];

  void tap() {
    final beat = DateTime.now();
    if (!_isLastBeatWithin(_resetTimeout, beat)) _reset();

    _addBeat(beat);
  }

  double get estimateBpm => getEstimate().bpm;

  Estimate getEstimate() {
    final trimmedList = Statistics.trim(_beatDurations);
    final listInMilliseconds =
        trimmedList.map((e) => e.inMilliseconds).toList();
    final mean = Statistics.mean(listInMilliseconds);
    final stdDev = Statistics.stdDev(listInMilliseconds);
    const oneMinuteMs = 60000;

    final bpmEstimate = oneMinuteMs / mean;

    final durationConfidenceRadius99Percent = _zStar99Percent *
        stdDev /
        sqrt(trimmedList.length) /
        _confidenceIntervalScale;
    // The radius becomes slightly asymmetric when inverted, so we take the
    //  larger one.
    double? bpmConfidenceRadius99Percent =
        oneMinuteMs / (mean - durationConfidenceRadius99Percent) - bpmEstimate;

    if (trimmedList.length < 4) bpmConfidenceRadius99Percent = null;

    return Estimate(
        bpm: bpmEstimate,
        confidenceRadius99Percent: bpmConfidenceRadius99Percent);
  }

  bool _isLastBeatWithin(Duration duration, DateTime beat) =>
      _lastBeat != null && beat.difference(_lastBeat!) < duration;

  void _reset() {
    _lastBeat = null;
    _beatDurations = [];
  }

  void _addBeat(DateTime beat) {
    _beatDurations.add(beat.difference(_lastBeat ?? beat));
    _lastBeat = beat;
  }
}

class Estimate {
  Estimate({required this.bpm, required this.confidenceRadius99Percent});
  final double bpm;
  final double? confidenceRadius99Percent;
}
