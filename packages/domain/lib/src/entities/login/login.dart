import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  const Login({
    required this.email,
    required this.password,
  });
  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  final String email;
  final String password;
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
