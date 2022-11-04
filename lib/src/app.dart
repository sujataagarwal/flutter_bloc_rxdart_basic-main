// ignore_for_file: prefer_const_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:poc_bloc/src/utils/snackbar_display.dart';
import 'blocs/connectivity_bloc.dart';
import 'ui/movie_list.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late String _message = '';
  late bool _internetStatus = false;

  @override
  void initState() {
    super.initState();
    connectivityBloc.checkInternetConnection();
    connectivityBloc.internetStatus.listen((data) {
      switch (data)
      {
        case ConnectivityResult.wifi:
        setState(() {
          _message = 'Internet Connect Restored';
          _internetStatus = true;
        });
        break;
        case ConnectivityResult.none:
        setState(() {
          _message = 'No Internet Connection';
          _internetStatus = false;
        });

        break;
      }
      setState(() {});
      SnackBarDisplay.buildSnackbar(_message, _internetStatus);
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies DB'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              TextButton(
                child: Text(
                  'Get List of movies',
                  style: TextStyle(fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(MovieList.routeName);
                },
              ),
              TextButton(
                child: Text(
                  'Login Form',
                  style: TextStyle(fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(MovieList.routeName);
                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}
