import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dfine_todo/bloc/theme/theme_bloc.dart';
import 'package:dfine_todo/shared/navigation_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_checkUserLoggedIn);
    on<SignInRequested>(_handleSignIn);
    on<SignUpRequested>(_handleSignUp);
    on<ForgotPasswordRequested>(_handleForgotPassword);
    on<SignOutRequested>(_handleSignOut);
  }

  // 1️⃣ Check if the user is already logged in
  Future<void> _checkUserLoggedIn(AppStarted event, Emitter<AuthState> emit) async {
    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    BlocProvider.of<ThemeBloc>(navigatorKey.currentContext!).add(LoadTheme());

    if (email != null) {
      emit(Authenticated(email: email)); // Restore logged-in state
    } else {
      emit(Unauthenticated());
    }
  }

  // 2️⃣ Handle Sign In
  Future<void> _handleSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: event.email, password: event.password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', event.email); // Save user email

      emit(Authenticated(email: event.email));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // 3️⃣ Handle Sign Up
  Future<void> _handleSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.createUserWithEmailAndPassword(email: event.email, password: event.password).then((value) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', event.email);
        await _firestore.collection("users").doc(value.user?.uid).set({
          "fullName": event.fullName,
          "email": event.email,
          "createdAt": DateTime.now(),
        });
      },);
      emit(Authenticated(email: event.email));


    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _handleForgotPassword(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: event.email.trim());
      emit(AuthPasswordResetSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // 4️⃣ Handle Sign Out
  Future<void> _handleSignOut(SignOutRequested event, Emitter<AuthState> emit) async {
    await _auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email'); // Remove user email

    emit(Unauthenticated());
  }
}

