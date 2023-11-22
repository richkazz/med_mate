import 'package:json_annotation/json_annotation.dart';

part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUp {
  factory SignUp.fromJson(Map<String, dynamic> json) => _$SignUpFromJson(json);

  const SignUp(
      {required this.name,
      required this.email,
      required this.password,
      required this.confirmPassword});

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  Map<String, dynamic> toJson() => _$SignUpToJson(this);
}
