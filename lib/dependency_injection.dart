import 'package:community_app/features/auth/data/datasources/login_data_source.dart';
import 'package:community_app/features/auth/domain/repositories/login_repository.dart';
import 'package:community_app/features/auth/domain/usecase/login_usercase.dart';
import 'package:get_it/get_it.dart';
import 'package:community_app/features/auth/data/repositories/login_repository_impl.dart';
import 'package:community_app/features/auth/presentation/bloc/login/login_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Bloc
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));

  // UseCase
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(sl()));

  // DataSource
  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl());
}
