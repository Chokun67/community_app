import 'package:community_app/features/auth/domain/usecase/login_usercase.dart';
import 'package:community_app/features/auth/presentation/bloc/login/login_event.dart';
import 'package:community_app/features/auth/presentation/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final storage = const FlutterSecureStorage(); 

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(LoginButtonPressed event, emit) async {
    emit(LoginLoading());
    try {
      final token = await loginUseCase(event.username, event.password);
      await storage.write(key: "auth_token", value: token);
      emit(LoginSuccess(token: token));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
