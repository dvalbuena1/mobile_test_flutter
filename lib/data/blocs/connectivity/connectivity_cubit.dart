import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_flutter/data/blocs/connectivity/connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;

  ConnectivityCubit({required this.connectivity})
      : super(UnknownConnectivityState());

  void listenConnectivity() {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setConnectivityState(result);
    });
  }

  Future<void> checkConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    setConnectivityState(result);
  }

  void setConnectivityState(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      emit(DisconnectedConnectivityState());
    } else {
      emit(ConnectedConnectivityState());
    }
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
