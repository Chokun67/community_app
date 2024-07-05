import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String password;
  final String firstName;
  final String lastName;

  RegisterButtonPressed({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [username, password, firstName, lastName];
}
