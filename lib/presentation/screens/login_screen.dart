import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/shared_button.dart';
import '../widgets/shared_text_field.dart';

import '../../core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Welcome to\nBelema Bank',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black, // Dark text
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Secure banking at your fingertips.',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: AppColors.textDark.withOpacity(
                        0.54,
                      ), // Darker grey text
                    ),
                  ),
                  const SizedBox(height: 60),
                  SharedTextField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  SharedTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isVisible: _isPasswordVisible,
                    onVisibilityChanged: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SharedButton(
                        label: 'Login',
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              LoginSubmitted(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
