// @dart=2.9

import 'package:flutter/material.dart';
import 'package:poc_bloc/src/app.dart';
import 'package:poc_bloc/src/ui/movie_detail.dart';
import 'package:poc_bloc/src/ui/movie_list.dart';
import 'global.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movie Database',
        scaffoldMessengerKey: snackBarKey,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          errorColor: Colors.red,
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Colors.purpleAccent,
            elevation: 10,
            contentTextStyle: TextStyle(color: Colors.black, fontSize: 10),
            actionTextColor: Colors.red,
          ),
        ),
        home: App(),
        initialRoute: MovieList.routeName,
        routes: {
          MovieList.routeName: (context) => MovieList(),
          MovieDetails.routeName: (context) => const MovieDetails()
        });
  }
}
