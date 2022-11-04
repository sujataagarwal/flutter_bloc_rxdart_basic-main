// @dart=2.9

import 'package:flutter/material.dart';
import 'package:poc_bloc/src/app.dart';
import 'package:poc_bloc/src/ui/movie_detail.dart';
import 'package:poc_bloc/src/ui/movie_list.dart';
import 'global.dart';
import 'package:poc_bloc/src/utils/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
          title: 'Movie Data base',
          scaffoldMessengerKey: snackBarKey,
    theme: ThemeData(
          primarySwatch: ColorUtils.PRIMARY_COLOR_DARK,
          errorColor: ColorUtils.ERROR_COLOR,
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: ColorUtils.WARNING_COLOR,
            elevation: 10,
            contentTextStyle: TextStyle (color: Colors.black, fontSize: 10),
            actionTextColor: Colors.red,
          ),
        ),
          home: App(),
          routes: {
            MovieList.routeName: (context) => MovieList(),
            MovieDetails.routeName: (context) => MovieDetails()
          });

  }
}
