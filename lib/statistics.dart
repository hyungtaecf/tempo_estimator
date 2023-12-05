part of 'tempo_estimator.dart';

class Statistics {
  static num total(Iterable<num> l) {
    return l.fold(0, (prev, element) => prev + element);
  }

  /// Calculates Mean
  static num mean(Iterable<num> list) {
    return total(list) / list.length;
  }

  /// Removes the highest 5% and lowest 5% of values in l (rounded up to a whole
  /// number of entries in each case, and returns the rest sorted.
  ///
  /// From timer.cubing.net
  static List<Duration> trim(List<Duration> l) {
    int len = l.length;
    if (len < 3) return [];

    int trimFromEachEnd = (len / 20).ceil();
    return (l..sort()).sublist(trimFromEachEnd, len - trimFromEachEnd);
  }

  /// Calculates standard deviation
  static num stdDev(List<num> list) {
    final m = mean(list);
    List<double> deltas = list.map((i) => pow(i - m, 2).toDouble()).toList();
    return sqrt(mean(deltas));
  }
}
