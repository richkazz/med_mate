import 'dart:convert';

import 'package:domain/domain.dart';
import 'package:med_mate/application/application.dart';

class AuthenticationRepository {
  AuthenticationRepository(
    this._httpService, {
    required ResultService resultService,
  }) : _resultService = resultService;
  final HttpService _httpService;
  final ResultService _resultService;
  Future<Result<User>> signUp(SignUp signUp) async {
    try {
      final body = json.encode(signUp.toJson());
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
}
