import 'package:dfine_todo/core/utils/typedef.dart';
import 'package:dfine_todo/features/authentication/domain/entity/user_entity.dart';

abstract class AuhtenticationRepository {
  ResultFuture<UserEntity> signUpWithUsernamePassword(
      {required email, required String password, required String fullName});
  ResultFuture<UserEntity> signInWithUsernamePassword(
      {required String email, required String password});
}
