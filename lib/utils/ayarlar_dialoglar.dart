import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';

class AyarlarDialoglar {
  AyarlarDialoglar._();

  // 1. ÇIKIŞ YAP ONAY DİYALOGU
  static Future<bool?> cikisYapOnayGoster(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return AlertDialog(
          backgroundColor: colors.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: colors.onErrorContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.cikisYapTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            l10n.cikisYapOnayIcerik,
            style: TextStyle(
              fontSize: 15,
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx, false);
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.iptal,
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.onError,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.pop(ctx, true);
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.cikisYapTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 2. ŞİFRE DEĞİŞTİR DİYALOGU
  static Future<String?> sifreDegistirGoster({
    required BuildContext context,
    required String? mevcutEmail,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<String>(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return _SifreDegistirDialog(
          mevcutEmail: mevcutEmail,
          l10n: l10n,
          colors: colors,
        );
      },
    );
  }

  // 3. ŞEHİR SEÇİM DİYALOGU
  static Future<String?> sehirSecimGoster({
    required BuildContext context,
    required String mevcutSehir,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<String>(
      context: context,
      builder: (ctx) {
        final colors = Theme.of(ctx).colorScheme;

        return _SehirSecimDialog(
          mevcutSehir: mevcutSehir,
          l10n: l10n,
          colors: colors,
        );
      },
    );
  }
}

class _SifreDegistirDialog extends StatefulWidget {
  final String? mevcutEmail;
  final AppLocalizations l10n;
  final ColorScheme colors;

  const _SifreDegistirDialog({
    required this.mevcutEmail,
    required this.l10n,
    required this.colors,
  });

  @override
  State<_SifreDegistirDialog> createState() => _SifreDegistirDialogState();
}

class _SifreDegistirDialogState extends State<_SifreDegistirDialog> {
  late final TextEditingController _controller;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.mevcutEmail ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Adres hatalıysa istek gönderilmez; kullanıcı düzeltmeyi burada görür.
  void _gonder() {
    final eposta = _controller.text.trim();
    final gecerli = eposta.contains('@') &&
        !eposta.contains(' ') &&
        eposta.indexOf('@') > 0 &&
        eposta.indexOf('@') < eposta.length - 1;

    if (!gecerli) {
      HapticFeedback.selectionClick();
      setState(() => _hata = widget.l10n.gecerliBirEpostaGiriniz);
      return;
    }

    HapticFeedback.mediumImpact();
    Navigator.pop(context, eposta);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.colors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              color: widget.colors.onPrimaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.l10n.sifreDegistirTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: widget.colors.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.l10n.sifreSifirlamaAciklama,
              style: TextStyle(
                fontSize: 13,
                color: widget.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              style: TextStyle(color: widget.colors.onSurface),
              onChanged: (_) {
                if (_hata != null) setState(() => _hata = null);
              },
              decoration: InputDecoration(
                labelText: widget.l10n.epostaAdresi,
                errorText: _hata,
                labelStyle: TextStyle(color: widget.colors.onSurfaceVariant),
                prefixIcon: Icon(
                  Icons.email_rounded,
                  size: 20,
                  color: widget.colors.primary,
                ),
                filled: true,
                fillColor: widget.colors.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context, null);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.l10n.iptal,
              style: TextStyle(
                color: widget.colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: widget.colors.primary,
            foregroundColor: widget.colors.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: _gonder,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.l10n.baglantiGonder,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SehirSecimDialog extends StatefulWidget {
  final String mevcutSehir;
  final AppLocalizations l10n;
  final ColorScheme colors;

  const _SehirSecimDialog({
    required this.mevcutSehir,
    required this.l10n,
    required this.colors,
  });

  @override
  State<_SehirSecimDialog> createState() => _SehirSecimDialogState();
}

class _SehirSecimDialogState extends State<_SehirSecimDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.mevcutSehir == 'Otomatik (GPS)' ? '' : widget.mevcutSehir,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.colors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      title: Text(
        widget.l10n.varsayilanSehirBolge,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: widget.colors.onSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: TextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(color: widget.colors.onSurface),
          decoration: InputDecoration(
            hintText: widget.l10n.sehirOrnekHint,
            hintStyle: TextStyle(color: widget.colors.onSurfaceVariant),
            prefixIcon: Icon(
              Icons.location_city_rounded,
              size: 20,
              color: widget.colors.primary,
            ),
            filled: true,
            fillColor: widget.colors.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context, 'Otomatik (GPS)');
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.l10n.gpsKullan,
              style: TextStyle(
                color: widget.colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: widget.colors.primary,
            foregroundColor: widget.colors.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context, _controller.text.trim());
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.l10n.kaydet,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
