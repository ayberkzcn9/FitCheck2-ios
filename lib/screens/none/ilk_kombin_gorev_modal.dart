import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

class IlkKombinGorevModal extends StatefulWidget {
  final VoidCallback onStilSecildi;

  const IlkKombinGorevModal({
    super.key,
    required this.onStilSecildi,
  });

  static void goster({
    required BuildContext context,
    required VoidCallback onStilSecildi,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => IlkKombinGorevModal(onStilSecildi: onStilSecildi),
    );
  }

  @override
  State<IlkKombinGorevModal> createState() => _IlkKombinGorevModalState();
}

class _IlkKombinGorevModalState extends State<IlkKombinGorevModal> {
  bool _yukleniyor = false;

  Future<void> stilSecildi(String promt) async {
    if (_yukleniyor) return;
    setState(() => _yukleniyor = true);
    try {
      widget.onStilSecildi();
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF343A40);

    final stiller = [
      {'baslik': l10n.stilKahveBaslik, 'promt': l10n.stilKahveSoru, 'icon': Icons.local_cafe_rounded},
      {'baslik': l10n.stilOfisBaslik, 'promt': l10n.stilOfisSoru, 'icon': Icons.work_rounded},
      {'baslik': l10n.stilSporBaslik, 'promt': l10n.stilSporSoru, 'icon': Icons.directions_run_rounded},
      {'baslik': l10n.stilGeceBaslik, 'promt': l10n.stilGeceSoru, 'icon': Icons.nightlife_rounded},
    ];

    // Uygulama sabit light modda
    const dialogBgColor = Colors.white;
    const titleColor = Color(0xFF1C1C1E);
    final subtitleColor = Colors.grey.shade600;
    const buttonBgColor = Color(0xFF000000);
    const buttonTextColor = Colors.white;
    const buttonBorderColor = Colors.transparent;

    return Dialog(
      backgroundColor: dialogBgColor,
      surfaceTintColor: Colors.transparent,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: const BorderSide(color: buttonBorderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome_rounded, size: 40, color: primaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.ilkGorevBaslik,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: titleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.ilkGorevAciklama,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            ...stiller.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonBgColor,
                        foregroundColor: buttonTextColor,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        side: const BorderSide(color: buttonBorderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: _yukleniyor
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              stilSecildi(s['promt'] as String);
                            },
                      child: Row(
                        children: [
                          Icon(
                            s['icon'] as IconData,
                            size: 20,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              s['baslik'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: buttonTextColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: subtitleColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}