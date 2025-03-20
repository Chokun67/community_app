import 'package:community_app/features/auth/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<String> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
