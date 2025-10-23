import 'package:dartz/dartz.dart';
import 'package:dfine_todo/core/exeption/exception.dart';
import 'package:dfine_todo/core/failure/failure.dart';
import 'package:dfine_todo/core/utils/typedef.dart';
import 'package:dfine_todo/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:dfine_todo/features/authentication/domain/entity/user_entity.dart';
import 'package:dfine_todo/features/authentication/domain/repository/auhtentication_repository.dart';

class AuthRepoImpl implements AuhtenticationRepository {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDatasource _remoteDataSource;
  @override
  ResultFuture<UserEntity> signInWithUsernamePassword(
      {required String email, required String password}) async {
    try {
      final result =
          await _remoteDataSource.signIn(email: email, password: password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserEntity> signUpWithUsernamePassword(
      {required email,
      required String password,
      required String fullName}) async {
    try {
      final result = await _remoteDataSource.signUp(
          fullName: fullName, email: email, password: password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
