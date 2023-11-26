import 'package:domain/domain.dart';
import 'package:med_mate/application/application.dart';

class DoctorRepository {
  DoctorRepository(
    this._httpService, {
    required ResultService resultService,
  }) : _resultService = resultService;
  final HttpService _httpService;
  final ResultService _resultService;
  Future<Result<bool>> linkADoctor(String email) async {
    return _resultService.successful<bool>(true);
  }
}
