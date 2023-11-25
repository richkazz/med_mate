// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/widgets.dart';

@immutable
class SignUp {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  const SignUp({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });

  SignUp copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? password,
  }) {
    return SignUp(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
    };
  }

  factory SignUp.fromMap(Map<String, dynamic> map) {
    return SignUp(
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUp.fromJson(String source) =>
      SignUp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SignUp(firstname: $firstname, lastname: $lastname, email: $email, '
        'password: $password)';
  }

  @override
  bool operator ==(covariant SignUp other) {
    if (identical(this, other)) return true;

    return other.firstname == firstname &&
        other.lastname == lastname &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return firstname.hashCode ^
        lastname.hashCode ^
        email.hashCode ^
        password.hashCode;
  }
}
