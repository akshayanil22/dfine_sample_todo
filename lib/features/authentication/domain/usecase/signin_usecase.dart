import 'package:dfine_todo/core/usecase/usecase.dart';
import 'package:dfine_todo/core/utils/typedef.dart';
import 'package:dfine_todo/features/authentication/domain/entity/user_entity.dart';
import 'package:dfine_todo/features/authentication/domain/repository/auhtentication_repository.dart';
import 'package:equatable/equatable.dart';

class SigninUsecase implements Usecase<UserEntity, SignInParams> {
  const SigninUsecase({required this.authRepo});
  final AuhtenticationRepository authRepo;
  @override
  ResultFuture<UserEntity> call(SignInParams params) {
    return authRepo.signInWithUsernamePassword(
        email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}
