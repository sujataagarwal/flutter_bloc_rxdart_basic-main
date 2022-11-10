import 'package:flutter/material.dart';
import 'package:poc_bloc/src/app.dart';

import '../location/ui/location_screen.dart';
import '../login/ui/login_screen.dart';
import '../movies/ui/movie_detail.dart';
import '../movies/ui/movie_list.dart';

class CommonRoutes {
  static MaterialPageRoute generateRoutes(RouteSettings settings)
  {
    if (settings.name ==  '/') return MaterialPageRoute(builder: (context) => App());
    if (settings.name == MovieList().routeName) return MaterialPageRoute(builder: (context) => MovieList());
    if (settings.name == const MovieDetails().routeName) return MaterialPageRoute(builder: (context) => const MovieDetails());
    if (settings.name == LoginScreen().routeName) return MaterialPageRoute(builder: (context) => LoginScreen());
    if (settings.name == const LocationScreen().routeName) return MaterialPageRoute(builder: (context) => const LocationScreen());
    return MaterialPageRoute(builder: (context) => App());
  }
}


