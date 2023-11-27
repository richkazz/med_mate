// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';

import 'package:med_mate/application/application.dart';
import 'package:med_mate/application/model/auth_response.dart';

class AuthenticationRepository {
  AuthenticationRepository(
    this._httpService, {
    required ResultService resultService,
    required ValueNotifier<String> tokenValueNotifier,
  })  : _resultService = resultService,
        _tokenValueNotifier = tokenValueNotifier;
  final HttpService _httpService;
  final ResultService _resultService;
  final userController = StreamController<User>.broadcast();
  final ValueNotifier<String> _tokenValueNotifier;
  Future<Result<bool>> signUp(SignUp signUp) async {
    try {
      final body = signUp.toJson();
      await _httpService.post('auth/registerUser', data: body);
      return _resultService.successful(true);
    } on NetWorkFailure catch (_) {
      return _resultService.error('Network failure');
    } on HttpException catch (e) {
      return _resultService.error(e.message ?? 'Something went wrong.');
    } on DioException catch (e) {
      if (e.response.isNull) {
        return _resultService.error('Something went wrong');
      }
      final response = ApiResponse.fromMap(e.response!.data! as DynamicMap);
      if (response.message == 'EMAIL_ALREADY_EXIST') {
        return _resultService.error('Email already exist.');
      }
      return _resultService.error('Something went wrong');
    } on Exception catch (e) {
      return _resultService.error('Something went wrong');
    }
  }

  Stream<User> get userStream => userController.stream;
  Future<void> signOut() async {
    userController.add(User.anonymous);
  }

  Future<Result<User>> signIn(Login login) async {
    try {
      final body = login.toJson();
      final response = await _httpService.post('auth/authenticate', data: body);
      final apiResponse = ApiResponse.fromMap(response as DynamicMap);
      final loginResponse =
          LoginResponse.fromMap(apiResponse.response as DynamicMap);
      _tokenValueNotifier.value = loginResponse.token;
      userController.add(
        User(
          isAnonymous: false,
          uid: loginResponse.userId,
          isNewUser: false,
          email: login.email,
          emailVerified: true,
          displayName: '${loginResponse.lastName} ${loginResponse.firstName}',
        ),
      );
      return _resultService.successful(User.anonymous);
    } on NetWorkFailure catch (_) {
      return _resultService
          .error('Check your internet connection and try again');
    } on HttpException catch (_) {
      return _resultService.error('Something went wrong');
    } on DioException catch (_) {
      return _resultService.error('Incorrect email or password');
    } on Exception catch (e) {
      return _resultService.error('Something went wrong');
    }
  }
}

class LoginResponse {
  final String token;
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
  });
  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      token: map['token'] as String,
      userId: map['userId'] as int,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
    );
  }
}
