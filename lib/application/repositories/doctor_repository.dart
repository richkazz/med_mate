import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:med_mate/application/application.dart';

class DoctorRepository {
  DoctorRepository(
    this._httpService, {
    required ResultService resultService,
  }) : _resultService = resultService;
  final HttpService _httpService;
  final ResultService _resultService;
  Future<Result<bool>> linkADoctor(String email, int userId) async {
    try {
      return _resultService.successful<bool>(true);
    } on NetWorkFailure catch (_) {
      return _resultService
          .error('Check your internet connection and try again');
    } on HttpException catch (_) {
      return _resultService.error('Something went wrong');
    } on DioException catch (_) {
      return _resultService.error('Something went wrong');
    } on Exception catch (e) {
      return _resultService.error('Something went wrong');
    }
  }
}
