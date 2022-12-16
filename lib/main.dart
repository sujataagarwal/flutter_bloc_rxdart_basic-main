// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:poc_bloc/src/app.dart';
import 'package:poc_bloc/src/location/bloc/geofence_bloc.dart';
import 'package:poc_bloc/src/utils/notify_service.dart';
import 'package:poc_bloc/src/utils/routes.dart';
import 'global.dart';
import 'package:poc_bloc/src/utils/color.dart';

Future<void> initializeService() async {
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText:
    "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool success =
  await FlutterBackground.initialize(androidConfig: androidConfig);
  NotifyService.showTextNotification(title: "PCO", body: "Success $success");
  bool success1 = await FlutterBackground.enableBackgroundExecution();
  NotifyService.showTextNotification(title: "PCO", body: "Success1 $success1");
  if (success1) {
    geofenceBloc.initializeGeofence();
    //startServiceInPlatform();
  }
}

Future<dynamic> _androidMethodCallHandler(MethodCall call) async {
  switch (call.method) {
    case 'locationTrackingService':
      var pathLocation = jsonDecode(call.arguments);
      print("Location Received --> $pathLocation");
      NotifyService.showTextNotification(title: 'POC_BLOCHandler', body: "$pathLocation");
      break;
  }
}

void startServiceInPlatform() async {
  if (Platform.isAndroid) {
    var methodChannel = const MethodChannel("poc_bloc");
    methodChannel.setMethodCallHandler(_androidMethodCallHandler);
    await methodChannel.invokeMethod("startService");
    String result = await methodChannel.invokeMethod("startTrackingService");
    NotifyService.showTextNotification(title: 'POC_BLOC', body: result);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotifyService.initialize(flutterLocalNotificationsPlugin);
  initializeService();
  // startServiceInPlatform();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'POC',
      scaffoldMessengerKey: snackBarKey,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        errorColor: Colors.red,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: ColorUtils.WARNING_COLOR,
          elevation: 10,
          contentTextStyle: TextStyle(color: Colors.black, fontSize: 10),
          actionTextColor: Colors.red,
        ),
      ),
      home: App(),
      onGenerateRoute: CommonRoutes.generateRoutes,
    );
  }
}
