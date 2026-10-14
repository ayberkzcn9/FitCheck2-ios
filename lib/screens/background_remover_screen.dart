// Yerel sunucu tabanlı arka plan silme test ekranı.
// Görsel seç → yerel sunucuya gönder → arka planı silinmiş sonucu göster.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/background_remover_service.dart';

class BackgroundRemoverScreen extends StatefulWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  State<BackgroundRemoverScreen> createState() =>
      _BackgroundRemoverScreenState();
}

class _BackgroundRemoverScreenState extends State<BackgroundRemoverScreen> {
  final _picker = ImagePicker();
  File? _original;
  File? _result;
  bool _loading = false;
  bool? _sunucuDurumu; // null=bilinmiyor, true=çalışıyor, false=kapalı

  @override
  void initState() {
    super.initState();
    _sunucuyuKontrolEt();
  }

  Future<void> _sunucuyuKontrolEt() async {
    final ok = await BackgroundRemoverService.sunucuSaglikliMi();
    if (mounted) setState(() => _sunucuDurumu = ok);
  }

  Future<void> _pickAndRemove() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      _original = File(picked.path);
      _result = null;
      _loading = true;
    });

    final bytes = await BackgroundRemoverService.removeBackground(_original!);

    if (!mounted) return;

    if (bytes != null) {
      final saved = await BackgroundRemoverService.saveResult(bytes);
      if (!mounted) return;
      setState(() {
        _result = saved;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başarısız, tekrar deneyin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arka Plan Sil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔌 Sunucu bağlantı durumu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: _sunucuDurumu == true
                    ? Colors.green.withValues(alpha: 0.12)
                    : _sunucuDurumu == false
                        ? Colors.red.withValues(alpha: 0.12)
                        : Colors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _sunucuDurumu == true
                        ? Icons.check_circle_rounded
                        : _sunucuDurumu == false
                            ? Icons.error_rounded
                            : Icons.sync_rounded,
                    size: 18,
                    color: _sunucuDurumu == true
                        ? Colors.green
                        : _sunucuDurumu == false
                            ? Colors.red
                            : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _sunucuDurumu == true
                          ? 'Sunucu bağlı (${BackgroundRemoverService.baseUrl})'
                          : _sunucuDurumu == false
                              ? 'Sunucuya ulaşılamadı — IP/port kontrol et'
                              : 'Sunucu kontrol ediliyor...',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    onPressed: _sunucuyuKontrolEt,
                    tooltip: 'Tekrar kontrol et',
                  ),
                ],
              ),
            ),
            Expanded(
              child: _original != null
                  ? Image.file(_original!, fit: BoxFit.contain)
                  : const Center(child: Text('Görsel seçin')),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_fix_high),
                label: Text(_loading ? 'İşleniyor...' : 'Arka Planı Sil'),
                onPressed: _loading ? null : _pickAndRemove,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              const Text('Sonuç',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Image.file(_result!, fit: BoxFit.contain),
              ),
            ],
          ],
        ),
      ),
    );
  }
}