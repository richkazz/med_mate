import 'package:domain/domain.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/bootstrap.dart';

void main() {
  bootstrap(
    (
      drugRepository,
      doctorRepository,
      netWorkInfo,
      httpService,
      authenticationRepository,
    ) =>
        App(
      user: User.anonymous,
      networkInfoImpl: netWorkInfo,
      drugRepository: drugRepository,
      doctorRepository: doctorRepository,
      httpService: httpService,
      authenticationRepository: authenticationRepository,
    ),
  );
}
