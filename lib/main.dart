import 'package:community_app/view/home_page.dart';
import 'package:community_app/view/login_page.dart';
import 'package:community_app/view/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:community_app/bloc/auth/auth_bloc.dart';
import 'package:community_app/bloc/auth/auth_event.dart';
import 'package:community_app/bloc/auth/auth_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const secureStorage = FlutterSecureStorage();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(secureStorage: secureStorage)..add(AppStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Bloc Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => const HomePage(),
        },
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitialized) {
              return const SplashScreen();
            } else if (state is Unauthenticated) {
              return LoginPage();
            } else if (state is Authenticated) {
              return const HomePage();
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
