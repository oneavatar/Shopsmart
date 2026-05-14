import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopsmart/features/auth/bloc/auth_event.dart';
import 'package:shopsmart/features/auth/bloc/auth_state.dart';

import 'package:shopsmart/features/auth/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);

    on<SignupRequested>(_onSignupRequested);

    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,

    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.login(
        email: event.email,

        password: event.password,
      );

      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(message: '', "Login failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: '', e.toString()));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,

    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.signup(
        email: event.email,

        password: event.password,
      );

      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(message: '', "Signup failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: '', e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,

    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.logout();

      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(message: '', e.toString()));
    }
  }
}
