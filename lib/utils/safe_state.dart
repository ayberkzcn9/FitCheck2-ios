// Safe State Helpers - Merkezi mounted guard ve async güvenlik yardımcıları
// Tüm ekranlarda (haftalık, anlık, ana ekran) tek kaynak kullanılır.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Güvenli setState - mounted kontrolü ile
/// Kullanım: `safeSetState(() { _degisken = yeniDeger; });`
void safeSetState(VoidCallback fn, {required bool mounted}) {
  if (mounted) {
    fn();
  }
}

/// Güvenli async callback - mounted kontrolü ile await sonrası
/// Kullanım:
/// ```dart
/// await futureIslem();
/// safeAsync(() => setState(() { _yukleniyor = false; }), mounted: mounted);
/// ```
void safeAsync(void Function() fn, {required bool mounted}) {
  if (mounted) {
    fn();
  }
}

/// Future için mounted guard - await sonrası çalıştırılacak callback'i güvenli hale getirir
/// ```dart
/// await Future.delayed(Duration(seconds: 1));
/// if (!mounted) return; // Yerine:
/// await futureWithGuard(() async {
///   await Future.delayed(Duration(seconds: 1));
///   setState(() { _yukleniyor = false; });
/// }, mounted: mounted);
/// ```
Future<void> futureWithGuard(Future<void> Function() futureFn, {required bool mounted}) async {
  if (!mounted) return;
  await futureFn();
  if (!mounted) return;
}

/// Stream subscription için güvenli dinleyici
/// ```dart
/// final sub = stream.listen((event) {
///   safeStreamCallback(() => setState(() { _veri = event; }), mounted: mounted);
/// });
/// ```
void safeStreamCallback(void Function() fn, {required bool mounted}) {
  if (mounted) {
    fn();
  }
}

/// ChangeNotifier veya ValueNotifier için güvenli listener ekleme
/// Dispose otomatik çağrılır.
class SafeListener<T> {
  final ValueListenable<T> listenable;
  final void Function(T value) onChange;
  bool _disposed = false;

  SafeListener(this.listenable, this.onChange) {
    listenable.addListener(_listener);
  }

  void _listener() {
    if (!_disposed) {
      onChange(listenable.value);
    }
  }

  void dispose() {
    _disposed = true;
    listenable.removeListener(_listener);
  }
}

/// Mixin: State sınıflarında kolay mounted guard sağlar
mixin SafeStateMixin<T extends StatefulWidget> on State<T> {
  /// Güvenli setState
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      fn();
    }
  }

  /// Güvenli async callback
  void safeAsync(void Function() fn) {
    if (mounted) {
      fn();
    }
  }

  /// Future ile güvenli await
  Future<void> safeFuture(Future<void> Function() futureFn) async {
    if (!mounted) return;
    await futureFn();
    if (!mounted) return;
  }
}