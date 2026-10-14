import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final void Function() onPhoneShake;
  final double shakeThresholdGravity;
  final int minimumShakeCount;
  final int shakeSlopTimeMS;
  final int shakeCountResetTime;

  StreamSubscription<AccelerometerEvent>? _subscription;
  int _shakeCount = 0;
  int _lastShakeTime = 0;

  ShakeDetector.autoStart({
    required this.onPhoneShake,
    this.shakeThresholdGravity = 2.7,
    this.minimumShakeCount = 1,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
  }) {
    startListening();
  }

  void startListening() {
    _subscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        double gX = event.x / 9.80665;
        double gY = event.y / 9.80665;
        double gZ = event.z / 9.80665;

        double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        if (gForce > shakeThresholdGravity) {
          final now = DateTime.now().millisecondsSinceEpoch;

          if (_lastShakeTime + shakeSlopTimeMS > now) {
            return;
          }

          if (_lastShakeTime + shakeCountResetTime < now) {
            _shakeCount = 0;
          }

          _lastShakeTime = now;
          _shakeCount++;

          if (_shakeCount >= minimumShakeCount) {
            _shakeCount = 0;
            try {
              onPhoneShake();
            } catch (_) {
              // Callback hatası sallama dinleyicisini bozmasın
            }
          }
        }
      },
      onError: (_) {
        // Sensör hatası: dinleyiciyi bozmadan yoksay
      },
      cancelOnError: false,
    );
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
}