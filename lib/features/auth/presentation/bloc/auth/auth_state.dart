import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String token;

  Authenticated({required this.token});

  @override
  List<Object> get props => [token];
}

class Unauthenticated extends AuthenticationState {}