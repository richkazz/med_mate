import 'dart:async';

import 'package:domain/domain.dart';
import 'package:med_mate/application/application.dart';

class AuthenticationRepository {
  AuthenticationRepository(
    this._httpService, {
    required ResultService resultService,
  }) : _resultService = resultService;
  final HttpService _httpService;
  final ResultService _resultService;
  final userController = StreamController<User>.broadcast();
  Future<Result<User>> signUp(SignUp signUp) async {
    try {
      final body = signUp.toJson();
      final response = await _httpService.post('auth/registerUser', data: body);
      return _resultService.successful(User.anonymous);
    } on NetWorkFailure catch (_) {
      return _resultService.error('Network failure');
    } on HttpException catch (_) {
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
      userController.add(
        User(
          isAnonymous: false,
          isNewUser: false,
          email: login.email,
          emailVerified: true,
          displayName: 'karo',
        ),
      );
      return _resultService.successful(User.anonymous);
    } on NetWorkFailure catch (_) {
      return _resultService.error('Network failure');
    } on HttpException catch (_) {
      return _resultService.error('Something went wrong');
    } on Exception catch (e) {
      //TODO:Remove
      userController.add(
        const User(
          isAnonymous: false,
          isNewUser: false,
          email: 'example@gmail.com',
          emailVerified: true,
          displayName: 'karo',
        ),
      );
      return _resultService.error('Something went wrong');
    }
  }
}
