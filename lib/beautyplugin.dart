import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Beautyplugin {
  static const MethodChannel _channel = const MethodChannel('beautyplugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get version async {
    final int? version = await _channel.invokeMethod('version');
    return version.toString();
  }

  static Future<Uint8List> beauty(
      Map<String, int> fairLevel, String faceInfo, Uint8List image) async {
    Uint8List bytes = await _channel.invokeMethod('beauty',
        {"fairLevel": fairLevel, "faceInfo": faceInfo, "image": image});
    return bytes;
  }
}
