// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/widgets.dart';

@immutable
class Login {
  const Login({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Login copyWith({
    String? email,
    String? password,
  }) {
    return Login(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Login.fromJson(String source) => Login.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Login(email: $email, password: $password)';

  @override
  bool operator ==(covariant Login other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
