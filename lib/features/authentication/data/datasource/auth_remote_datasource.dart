import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dfine_todo/core/exeption/exception.dart';
import 'package:dfine_todo/features/authentication/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDatasource {
  const AuthRemoteDatasource();
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp(
      {required String fullName,
      required String email,
      required String password});
}

class AuthRemoteDataSourceImpl extends AuthRemoteDatasource {
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  @override
  Future<UserModel> signIn(
      {required String email, required String password}) async {
    String fullName = '';
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      await _saveUserEmail(email); // Save user email

      final docSnapshot = await firebaseFirestore
          .collection('users')
          .doc(result.user?.uid)
          .get();

      if (docSnapshot.exists) {
        fullName = docSnapshot.data()?['fullName'] ?? '';
      }

      return UserModel(fullName: fullName, email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<UserModel> signUp(
      {required String fullName,
      required String email,
      required String password}) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _saveUserEmail(email);
      await firebaseFirestore.collection("users").doc(result.user?.uid).set({
        "fullName": fullName,
        "email": email,
        "createdAt": DateTime.now(),
      });

      return UserModel(fullName: fullName, email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: e.message ?? 'Error Occured', statusCode: e.code);
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  Future<void> _saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }
}
