A tool to help finding the BPM (beats per minute) by tapping.

## Features

- Get the tempo estimation with a 99% confidence interval.
- Simple and intuitive

## Usage

### Installing

Installation instructions can be found on the "Installing" tab on pub.dev.

### Importing

As always, import first this package:

```dart
import 'package:tempo_estimator/tempo_estimator.dart';
```

### Getting the tempo

```dart
// Keep the instance of TempoEstimator. Use the optional parameter resetTimeout to
// determine the maximum duration of a beat that can be counted. - Default is 5 seconds
final tempoEstimator = TempoEstimator(resetTimeout: const Duration(seconds: 3));

// Use the tap() method to update the tempo estimator. Add it somewhere in the UI to
// access it by tapping or just use it programmatically if you will.
void _onTap() => setState(() => tempoEstimator.tap());

// Access the current estimated tempo with the getter estimateBpm
print(tempoEstimator.estimateBpm);

// ...or get more details by using the getEstimate() method.
tempoEstimator.getEstimate().confidenceRadius99Percent;
```

## Additional information

This package is based on this algorithm: https://github.com/lgarron/bpm-tap
