// Stilist Hafızası modalı — kullanıcının "neler hatırlanıyor?" ekranı.
//
// Neden gerekli: hafıza cihazda kalıcı olarak tutuluyor; kullanıcı bunu
// görebilmeli ve tek dokunuşla silebilmelidir (kişisel veri kontrolü).
//
// Bu ekran yalnızca gösterim + temizleme yapar; hafızayı açma/kapama ana
// Ayarlar ekranındaki anahtardan yönetilir.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../services/stilist_hafizasi.dart';
import '../../theme/design_tokens.dart';

class StilistHafizasiModal extends StatefulWidget {
  /// Hafıza temizlendiğinde çağrılır (Ayarlar ekranı sayacı güncellenir).
  final VoidCallback? onDegisti;

  const StilistHafizasiModal({super.key, this.onDegisti});

  /// Modal'ı açmanın pratik yolu.
  static void goster({
    required BuildContext context,
    VoidCallback? onDegisti,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StilistHafizasiModal(onDegisti: onDegisti),
    );
  }

  @override
  State<StilistHafizasiModal> createState() => _StilistHafizasiModalState();
}

class _StilistHafizasiModalState extends State<StilistHafizasiModal> {
  List<String> _notlar = <String>[];
  String _ozet = '';
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  Future<void> _yukle() async {
    final hafiza = StilistHafizasi();
    await hafiza.yukle(zorla: true);
    if (!mounted) return;
    setState(() {
      _notlar = hafiza.notlar;
      _ozet = hafiza.ozet;
      _yukleniyor = false;
    });
  }

  Future<void> _temizleTetikle() async {
    final l10n = AppLocalizations.of(context)!;
    final onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.stilistHafizasiTemizle),
        content: Text(l10n.stilistHafizasiTemizleOnay),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.iptal),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppAccents.error),
            child: Text(l10n.tamam),
          ),
        ],
      ),
    );
    if (onay != true) return;

    HapticFeedback.mediumImpact();
    await StilistHafizasi().temizle();
    if (!mounted) return;
    setState(() {
      _notlar = <String>[];
      _ozet = '';
    });
    widget.onDegisti?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.stilistHafizasiTemizlendi)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final double altGuvenliBosluk = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        altGuvenliBosluk > 0 ? altGuvenliBosluk + 20 : 24,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppAccents.styleist.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: AppAccents.styleist,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.stilistHafizasiBaslik,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.stilistHafizasiAciklama,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            if (_yukleniyor)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_notlar.isEmpty && _ozet.trim().isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 20,
                      color: colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.stilistHafizasiBos,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Text(
                l10n.stilistHafizasiNelerBiliyor,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              ..._notlar.map(
                (not) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                          color: AppAccents.styleist,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            not,
                            style: TextStyle(
                              fontSize: 12.5,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_ozet.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.stilistHafizasiOzetBaslik,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _ozet.trim(),
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _temizleTetikle,
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  label: Text(l10n.stilistHafizasiTemizle),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppAccents.error,
                    side: BorderSide(
                      color: AppAccents.error.withValues(alpha: 0.4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
