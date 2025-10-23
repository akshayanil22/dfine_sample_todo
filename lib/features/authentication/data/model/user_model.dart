import 'package:dfine_todo/features/authentication/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.fullName, required super.email});

  UserModel copyWith({
    String? fullName,
    String? email,
  }) =>
      UserModel(
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fullName: json["fullName"] ?? '',
        email: json["email"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
      };
}
