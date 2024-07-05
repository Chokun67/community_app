import 'package:community_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_app/bloc/auth/auth_bloc.dart';
import 'package:community_app/bloc/login/login_bloc.dart';
import 'package:community_app/bloc/login/login_event.dart';
import 'package:community_app/bloc/login/login_state.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // ใช้ธีมสีที่นำเข้า
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: AppColors.primaryColor, // ใช้ธีมสีที่นำเข้า
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
        child: LoginForm(_usernameController, _passwordController),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;

  const LoginForm(this._usernameController, this._passwordController, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login Failed: ${state.error}'),
            backgroundColor: AppColors.errorColor, // ใช้ธีมสีที่นำเข้า
          ));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor, // ใช้ธีมสีที่นำเข้า
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.lock,
                            size: 100,
                            color: AppColors.primaryColor, // ใช้ธีมสีที่นำเข้า
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          state is LoginLoading
                              ? const CircularProgressIndicator()
                              : Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
                                          username: _usernameController.text,
                                          password: _passwordController.text,
                                        ));
                                      },
                                      child: const Text('Login'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/register');
                                      },
                                      child: const Text('Don\'t have an account? Register'),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
