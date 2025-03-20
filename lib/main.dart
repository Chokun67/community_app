import 'package:community_app/features/home/presentation/bloc/category/categories_bloc.dart';
import 'package:community_app/dependency_injection.dart';
import 'package:community_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:community_app/features/auth/presentation/pages/login_page.dart';
import 'package:community_app/features/home/presentation/pages/home_page.dart';

import 'package:community_app/components/nevigator.dart';
import 'package:community_app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:community_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:community_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:community_app/features/auth/presentation/bloc/auth/auth_state.dart';

void main() async{
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const secureStorage = FlutterSecureStorage();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => sl<LoginBloc>()),
        BlocProvider(
          create: (context) => AuthenticationBloc(secureStorage: secureStorage)..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => CategoriesBloc()..add(const FetchCategories()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Bloc Demo',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => const HomePage(),
        },
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return const SplashScreen();
            } else if (state is Unauthenticated) {
              return const LoginPage();
            } else if (state is Authenticated) {
              return const NavigatorPage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
