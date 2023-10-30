import 'package:tempo_estimator/tempo_estimator.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: BpmApp()));

class BpmApp extends StatefulWidget {
  const BpmApp({super.key});

  @override
  State createState() => _BpmAppState();
}

class _BpmAppState extends State<BpmApp> {
  final tempoEstimator = TempoEstimator();

  void _onTap() => setState(() => tempoEstimator.tap());

  @override
  Widget build(BuildContext context) {
    final estimate = tempoEstimator.getEstimate();
    return Scaffold(
      appBar: AppBar(title: const Text('BPM Tapper')),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTap,
        tooltip: 'Tap to Beat',
        child: const Icon(Icons.touch_app),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BPM: ${estimate.bpm.toStringAsFixed(1)}'),
            if (estimate.confidenceRadius99Percent != null)
              Text('Confidence Radius: '
                  '${estimate.confidenceRadius99Percent!.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}
