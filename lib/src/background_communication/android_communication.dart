import 'dart:io';

import 'package:flutter/services.dart';

const String METHOD_CHANNEL = "poc_bloc";

class AndroidCommunication {
  late MethodChannel _methodChannel;
  AndroidCommunication() {
    _methodChannel = MethodChannel(METHOD_CHANNEL);
  }

  Future invokeServiceInAndroid() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod("startTrackingService");
    }
  }

  Future stopServiceInAndroid() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod("stopTrackingService");
    }
  }

  Future isPetTrackingEnabled() async {
    if (Platform.isAndroid) {
      bool result = await _methodChannel.invokeMethod("isTrackingEnabled");
      return result;
    }
  }

  Future isServiceBound() async {
    if (Platform.isAndroid) {
      bool result = await _methodChannel.invokeMethod("serviceBound");
      if (result) {
        isPetTrackingEnabled();
      }
    }
  }
}