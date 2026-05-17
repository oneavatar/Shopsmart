import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/features/auth/bloc/auth_event.dart';
import 'package:shopsmart/features/auth/bloc/auth_state.dart';
import 'package:shopsmart/features/auth/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = authRepository.currentUser;
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthInitial());
    }
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
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Login failed"));
      }
    } on FirebaseAuthException catch (e) {
      String message = "Authentication failed";
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided.";
      } else if (e.code == 'invalid-email') {
        message = "The email address is badly formatted.";
      } else if (e.code == 'user-disabled') {
        message = "This user has been disabled.";
      }
      emit(AuthFailure(message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
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
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Signup failed"));
      }
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";
      if (e.code == 'email-already-in-use') {
        message = "The account already exists for that email.";
      } else if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == 'invalid-email') {
        message = "The email address is badly formatted.";
      }
      emit(AuthFailure(message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
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
      emit(AuthFailure(e.toString()));
    }
  }
}
