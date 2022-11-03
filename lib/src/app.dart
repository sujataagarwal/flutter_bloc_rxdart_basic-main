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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late AsyncSnapshot<ConnectivityResult> _source;

  late String message = '';

  late bool internetStatus = false;

  void initState() {
    super.initState();
    connectivityBloc.CheckInternetConnection();
    connectivityBloc.internetStatus.listen((data) {
      switch (data)
      {
        case ConnectivityResult.wifi: print ('Hello');
        setState(() {
          message = 'Internet Connect Restored';
          internetStatus = true;

        });
        break;
        case ConnectivityResult.none: print ('None');
        setState(() {
          message = 'No Internet Connection';
          internetStatus = false;
        });

        break;
      }
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontSize: 30),
          ),
        ),
      );
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
          Container(
            child: TextButton(
              child: Text(
                'Get List of movies',
                style: TextStyle(fontSize: 20,),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(MovieList.routeName);
              },
            ),
          ),

        ],
      ),

    );
  }
}
