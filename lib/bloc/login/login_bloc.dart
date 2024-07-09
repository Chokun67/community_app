import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:community_app/bloc/auth/auth_bloc.dart';
import 'package:community_app/bloc/auth/auth_event.dart';
import 'package:community_app/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.authenticationBloc}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/login'),
        body: {
          'username': event.username,
          'password': event.password,
        },
      );
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 201) {
        final token = json.decode(response.body)['access_token'];
        authenticationBloc.add(LoggedIn(token: token));
        emit(LoginInitial());
      } else {
        emit(LoginFailure(error: 'Login failed'));
      }
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }
  }
}
