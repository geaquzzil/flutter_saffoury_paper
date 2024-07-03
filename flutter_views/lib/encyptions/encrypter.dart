// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class Encriptions {
  static const String ENCRYPT_KEY = "qusasafo12345&!#";

  static String encypt(String text) {
    final key = Key.fromUtf8(ENCRYPT_KEY);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final bytes = encrypter.encrypt(text, iv: iv).bytes;
    Uint8List cipherIvBytes = Uint8List(bytes.length + iv.bytes.length)
      ..setAll(0, iv.bytes)
      ..setAll(iv.bytes.length, bytes);
    return base64.encode(cipherIvBytes);
  }
}
