import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/snackbar_display.dart';

class LocationBloc {
  final position = BehaviorSubject<Position>();
  final address = BehaviorSubject<String>();

  fetchCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    try {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      }
    } catch (e) {
      address.sink.addError(e);
    }
    Position receivedPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) {
      SnackBarDisplay.buildSnackbar('In Get Current location $position', false);

      return position;
    });
    position.sink.add(receivedPosition);
  }

  Stream<Position> get currentPosition => position.stream;

  fetchAddressFromLatLong(Position position) async {
    String currentAddress;
    try {
      await placemarkFromCoordinates(
          position.latitude, position.longitude).then((
          List<Placemark> placeMarks) {
        Placemark place = placeMarks[0];
        currentAddress = '${place.street}, ${place.subLocality}, ${place
            .subAdministrativeArea}, ${place.postalCode}';
        address.sink.add(currentAddress);

      });
    }
    catch (e) {
      address.sink.addError(e);
    }
  }
  Stream<String> get currentAddress => address.stream;
}

final locationBloc = LocationBloc();
