import 'package:equatable/equatable.dart';

abstract class ConnectivityState extends Equatable {}

class UnknownConnectivityState extends ConnectivityState {
  @override
  List<Object?> get props => [];
}

class ConnectedConnectivityState extends ConnectivityState {
  @override
  List<Object?> get props => [];
}

class DisconnectedConnectivityState extends ConnectivityState {
  @override
  List<Object?> get props => [];
}
