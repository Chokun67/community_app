import 'package:community_app/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:community_app/features/auth/presentation/bloc/register/register_event.dart';
import 'package:community_app/features/auth/presentation/bloc/register/register_state.dart';
import 'package:community_app/features/auth/presentation/components/login_button.dart';
import 'package:community_app/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Register',
            style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: RegisterForm(
          _usernameController,
          _passwordController,
          _firstNameController,
          _lastNameController,
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;
  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;

  const RegisterForm(
    this._usernameController,
    this._passwordController,
    this._firstNameController,
    this._lastNameController, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Register Failed: ${state.error}'),
            backgroundColor: Colors.red,
          ));
        }
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Register Success'),
            backgroundColor: Colors.green,
          ));
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.person_add,
                            size: 100,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                          state is RegisterLoading
                              ? const CircularProgressIndicator()
                              : CustomLoginButton(
                                  text: "Register",
                                  onPressed: () {
                                    BlocProvider.of<RegisterBloc>(context).add(
                                      RegisterButtonPressed(
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                      ),
                                    );
                                  },
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
