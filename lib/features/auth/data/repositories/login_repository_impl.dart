import 'package:community_app/features/auth/data/datasources/login_data_source.dart';
import 'package:community_app/features/auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login(String username, String password) async {
    return await remoteDataSource.login(username, password);
  }
}
