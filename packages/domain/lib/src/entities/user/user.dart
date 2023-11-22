import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String? displayName;
  final String? email;
  final bool? emailVerified;
  final bool isAnonymous;
  final String? uid;
  const User(
      {this.displayName,
      this.email,
      this.emailVerified,
      required this.isAnonymous,
      this.uid,
      required this.isNewUser});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Whether the user is new or not.
  final bool isNewUser;

  /// Anonymous user which represents an unauthenticated user.
  static const User anonymous =
      User(uid: '', isNewUser: true, isAnonymous: true);
}

class UserApp {
  String? userName;
  String? profilePic;
  String? standard;
  String? section;
  String? email;
  String? password;
  UserApp({
    this.userName,
    this.profilePic,
    this.section,
    this.standard,
    this.email,
    this.password,
  });
}
