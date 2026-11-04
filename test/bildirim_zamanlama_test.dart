import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitcheck/services/bildirim_servisi.dart';

void main() {
  group('Bildirim zamanlama modu', () {
    test('tam zamanlı alarm izni varsa exactAllowWhileIdle seçilir', () {
      expect(
        BildirimServisi.alarmModuSec(tamZamanliIzinVar: true),
        AndroidScheduleMode.exactAllowWhileIdle,
      );
    });

    test('izin yoksa inexactAllowWhileIdle seçilir', () {
      expect(
        BildirimServisi.alarmModuSec(tamZamanliIzinVar: false),
        AndroidScheduleMode.inexactAllowWhileIdle,
      );
    });

    test('izin yokken exact modu kullanılmaz (bildirim hiç kurulmazdı)', () {
      // Android 12+ "tam zamanlı alarm" izni verilmemişken exact modu
      // exact_alarms_not_permitted hatası fırlatır; eklenti hatası yutulduğu
      // için bildirim hiç planlanmıyordu. Güvenli mod inexact'tir.
      expect(
        BildirimServisi.alarmModuSec(tamZamanliIzinVar: false),
        isNot(AndroidScheduleMode.exact),
      );
      expect(
        BildirimServisi.alarmModuSec(tamZamanliIzinVar: false),
        isNot(AndroidScheduleMode.alarmClock),
      );
    });
  });
}
