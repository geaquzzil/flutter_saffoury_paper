import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class Compression {
  static String compress(var value, {bool returnCompresedJson = true}) {
    if (kIsWeb) {
      //TODO find solution
      return jsonEncode(value);
    }
    final enCodedJson =
        utf8.encode(returnCompresedJson ? jsonEncode(value) : value.toString());
    final gZipJson = gzip.encode(enCodedJson);
    return base64.encode(gZipJson);
  }

  static Object uncompress(String compressed,
      {bool returnCompresedJson = true}) {
    if (kIsWeb) {
      //TODO find solution
      return jsonDecode(compressed);
    }
    final decodeBase64Json = base64.decode(compressed);
    final decodegZipJson = gzip.decode(decodeBase64Json);
    final originalJson = utf8.decode(decodegZipJson);
    if (returnCompresedJson) {
      return jsonDecode(originalJson);
    }
    return originalJson;
  }
}
