import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class SnackBarDisplay {
  final String message;

  const SnackBarDisplay({
    required this.message,
  });

  static buildSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message', style: TextStyle(fontSize: 5, color: Colors.teal ), textAlign: TextAlign.center,),
        backgroundColor: Colors.grey,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // final String message;
  // final GlobalKey<ScaffoldState> scaffoldKey;
  //
  //
  // SnackBarDisplay(this.message, this.scaffoldKey);
  // @override
  // Widget build(BuildContext context) {
  //   print('Message $message');
  //   return   scaffoldKey.currentState.showSnackBar(
  //       SnackBar(
  //         content: const Text('Hi, I am a SnackBar!'),
  //         backgroundColor: (Colors.black12),
  //         action: SnackBarAction(
  //           label: 'dismiss',
  //           onPressed: () {},
  //         ),
  //       );
  //
  //
  //   );
  // }
}
