  import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

enum ConnectivityStatus
{
  online,
  offline
}

class ConnectivityBloc {
  final Connectivity _connectivity = Connectivity();
  //seedValue :ConnectionStatus.online
  // Default will be online. This controller will help to emit new states when the connection changes.
  final _controller = BehaviorSubject<ConnectivityResult>(seedValue: ConnectivityResult.none);
  StreamSubscription? _connectionSubscription;

  CheckInternetConnection() {
    _checkInternetConnection();
  }

  // The [ConnectionStatusValueNotifier] will subscribe to this
  // stream and everytime the connection status change it
  // will update it's value
  Observable  get internetStatus => _controller.stream;

  Future<void> _checkInternetConnection()
  async {
      // This 3 seconds delay will give some time to the device to connect to the internet in order to avoid false-positives
      await Future.delayed(const Duration(seconds: 3));
      final result = await _connectivity.onConnectivityChanged.listen((connectivityResult)
        async {
          try {
            if (connectivityResult == ConnectivityResult.wifi){
              _controller.sink.add(ConnectivityResult.wifi);
            }
            else
              _controller.sink.add(ConnectivityResult.none);
          }
          on SocketException catch (_) {
            _controller.sink.add(ConnectivityResult.none);
          }
      });
  }

  Future<void> close() async {
    // Cancel subscription and close controller
    await _connectionSubscription?.cancel();
    await _controller.close();
  }
}

final connectivityBloc = ConnectivityBloc();