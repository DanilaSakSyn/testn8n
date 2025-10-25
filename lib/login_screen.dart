import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events for LoginCubit
abstract class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);
}

class LoginSubmitted extends LoginEvent {}

// States for LoginCubit
class LoginState {
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  LoginState({
    required this.email,
    required this.password,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  factory LoginState.initial() {
    return LoginState(
      email: '',
      password: '',
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}

// Cubit that manages the state for login
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, isFailure: false));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, isFailure: false));
  }

  // Simulate a login process
  Future<void> logInWithCredentials() async {
    if (!state.isFormValid) {
      emit(state.copyWith(isFailure: true));
      return;
    }
    emit(state.copyWith(isSubmitting: true, isFailure: false, isSuccess: false));
    await Future.delayed(const Duration(seconds: 2)); // simulate network delay

    if (state.email == 'user@example.com' && state.password == 'password123') {
      emit(state.copyWith(isSubmitting: false, isSuccess: true, isFailure: false));
    } else {
      emit(state.copyWith(isSubmitting: false, isSuccess: false, isFailure: true));
    }
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Вход')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.isFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ошибка входа. Проверьте данные и попробуйте снова.')),
                );
              }
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Успешный вход!')),
                );
                // TODO: Navigate to main app screen
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _EmailInput(),
                const SizedBox(height: 12),
                _PasswordInput(),
                const SizedBox(height: 24),
                _LoginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Пароль',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.isSubmitting != current.isSubmitting || previous.isFormValid != current.isFormValid,
      builder: (context, state) {
        return state.isSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: state.isFormValid
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text('Войти'),
              );
      },
    );
  }
}
