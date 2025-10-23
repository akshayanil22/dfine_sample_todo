import 'package:dfine_todo/core/usecase/usecase.dart';
import 'package:dfine_todo/core/utils/typedef.dart';
import 'package:dfine_todo/features/authentication/domain/entity/user_entity.dart';
import 'package:dfine_todo/features/authentication/domain/repository/auhtentication_repository.dart';
import 'package:equatable/equatable.dart';

class SignupUsecase implements Usecase<void, SignUpParams> {
  SignupUsecase({required this.authRepo});
  final AuhtenticationRepository authRepo;
  @override
  ResultFuture<UserEntity> call(SignUpParams params) {
    return authRepo.signUpWithUsernamePassword(
        email: params.email,
        password: params.password,
        fullName: params.fullName);
  }
}

class SignUpParams extends Equatable {
  const SignUpParams(
      {required this.fullName, required this.email, required this.password});
  final String fullName;
  final String email;
  final String password;

  @override
  List<String> get props => [fullName, email, password];
}
