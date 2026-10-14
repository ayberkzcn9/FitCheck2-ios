import 'dart:typed_data';

class ChatMesaj {
  final String mesaj;
  final bool isUser;
  final Uint8List? resimBytes;

  ChatMesaj({
    required this.mesaj,
    required this.isUser,
    this.resimBytes,
  });
}