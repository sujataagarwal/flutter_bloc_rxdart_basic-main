//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:poc_bloc/src/location/bloc/location_bloc.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  @override
  Widget build(BuildContext context) {
    locationBloc.fetchCurrentLocation();
    return StreamBuilder<Position>(
        stream: locationBloc.currentPosition,
        builder: (context, curPos) {
          if (curPos.data != null) {
            return ListView(children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(5, 20, 10, 0),
                  child: Text('LAT: ${curPos.data!.latitude}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              const SizedBox( height: 10,),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(5, 20, 10, 0),
                  child: Text('LNG: ${curPos.data!.longitude}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              const SizedBox( height: 10,),
              Container(child: buildAddress(curPos.data!)),
            ]);
          }
          else {
            return Text('${curPos.error}');
          }
        }
        );
  }

  Widget buildAddress(Position curPos) {
    locationBloc.fetchAddressFromLatLong(curPos);
    return StreamBuilder<String>(
        stream: locationBloc.address,
        builder: (context, snapshot) {
          return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(5, 20, 10, 0),
              child: Text('Address: ${snapshot.data}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),));
        });
  }
}
