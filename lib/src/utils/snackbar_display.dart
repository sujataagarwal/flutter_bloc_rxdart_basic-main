import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:poc_bloc/global.dart';
import 'package:poc_bloc/src/utils/color.dart';

class SnackBarDisplay {
  static buildSnackbar(String message, bool internetStatus) {
    final SnackBar snackBar = SnackBar(
      content: Text('$message', style: TextStyle(fontSize: 20, color: Colors.black ), textAlign: TextAlign.center,),
      backgroundColor: internetStatus? ColorUtils.SUCCESS_COLOR : ColorUtils.ERROR_COLOR ,
      duration: Duration(seconds: 2),
    );
    snackBarKey.currentState?.showSnackBar(snackBar).close;
  }
}
