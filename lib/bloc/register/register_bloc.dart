import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:community_app/utility/constants.dart';
import 'package:http/http.dart' as http;
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onRegisterButtonPressed(
      RegisterButtonPressed event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());

    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/register'),
        body: {
          'username': event.username,
          'password': event.password,
          'firstName': event.firstName,
          'lastName': event.lastName,
        },
      );

      if (response.statusCode == 200) {
        emit(RegisterInitial());
      } else {
        emit(RegisterFailure(error: 'Register failed'));
      }
    } catch (error) {
      emit(RegisterFailure(error: error.toString()));
    }
  }
}
