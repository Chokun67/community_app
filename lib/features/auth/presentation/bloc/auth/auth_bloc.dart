import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FlutterSecureStorage secureStorage;

  AuthenticationBloc({required this.secureStorage}) : super(Uninitialized()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token != null) {
      emit(Authenticated(token: token));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(Authenticated(token: event.token));
    await secureStorage.write(key: 'auth_token', value: event.token);
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(Unauthenticated());
    await secureStorage.delete(key: 'auth_token');
  }
}
