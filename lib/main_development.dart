import 'package:domain/domain.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/bootstrap.dart';

void main() {
  bootstrap(
    (drugRepository, netWorkInfo, httpService, authenticationRepository) => App(
      user: User.anonymous,
      networkInfoImpl: netWorkInfo,
      drugRepository: drugRepository,
      httpService: httpService,
      authenticationRepository: authenticationRepository,
    ),
  );
}
