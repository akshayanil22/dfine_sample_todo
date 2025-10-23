import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dfine_todo/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:dfine_todo/features/authentication/data/repository/auth_repo_impl.dart';
import 'package:dfine_todo/features/authentication/domain/entity/user_entity.dart';
import 'package:dfine_todo/features/authentication/domain/usecase/signin_usecase.dart';
import 'package:dfine_todo/features/authentication/domain/usecase/signup_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SignupUsecase signupUsecase;
  late SigninUsecase signinUsecase;

  AuthBloc() : super(AuthInitial()) {
    final AuthRemoteDatasource authRemoteDataSourceImpl =
        AuthRemoteDataSourceImpl(
            firebaseAuth: _auth, firebaseFirestore: _firestore);
    final AuthRepoImpl auhtenticationRepository =
        AuthRepoImpl(authRemoteDataSourceImpl);
    signupUsecase = SignupUsecase(authRepo: auhtenticationRepository);
    signinUsecase = SigninUsecase(authRepo: auhtenticationRepository);

    on<AppStarted>(_checkUserLoggedIn);
    on<SignInRequested>(_handleSignIn);
    on<SignUpRequested>(_handleSignUp);
    on<ForgotPasswordRequested>(_handleForgotPassword);
    on<SignOutRequested>(_handleSignOut);
  }

  // 1️⃣ Check if the user is already logged in
  Future<void> _checkUserLoggedIn(
      AppStarted event, Emitter<AuthState> emit) async {
    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    if (email != null) {
      emit(Authenticated(
          userDetails: UserEntity(fullName: email, email: email)));
    } else {
      emit(Unauthenticated());
    }
  }

  // 2️⃣ Handle Sign In
  Future<void> _handleSignIn(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signinUsecase(
        SignInParams(email: event.email, password: event.password));
    result.fold(
        (l) => emit(AuthError(
            message: "Error : ${l.statusCode} message: ${l.message}")),
        (user) => emit(Authenticated(userDetails: user)));
  }

  // 3️⃣ Handle Sign Up
  Future<void> _handleSignUp(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signupUsecase(SignUpParams(
        fullName: event.fullName,
        email: event.email,
        password: event.password));
    result.fold(
        (l) => emit(AuthError(
            message: "Error : ${l.statusCode} message: ${l.message}")),
        (user) => emit(Authenticated(userDetails: user)));
  }

  Future<void> _handleForgotPassword(
      ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: event.email.trim());
      emit(AuthPasswordResetSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // 4️⃣ Handle Sign Out
  Future<void> _handleSignOut(
      SignOutRequested event, Emitter<AuthState> emit) async {
    await _auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email'); // Remove user email

    emit(Unauthenticated());
  }
}
