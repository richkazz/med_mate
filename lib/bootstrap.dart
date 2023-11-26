import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:domain/domain.dart';
import 'package:flutter/widgets.dart';
import 'package:med_mate/application/application.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function(
    DrugRepository drugRepository,
    DoctorRepository doctorRepository,
    NetworkInfoImpl networkInfoImpl,
    HttpService httpService,
    AuthenticationRepository authenticationRepository,
  ) builder,
) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();
  final resultService = ResultService();
  // Add cross-flavor configuration here
  final dataConnectionChecker = DataConnectionChecker();
  final networkInfo = NetworkInfoImpl(dataConnectionChecker);
  final httpService = DioHttpService(
    networkInfo: networkInfo,
    baseUrl: 'http://medmatebackend2-production.up.railway.app/api/v1/',
    headers: {'Content-Type': 'application/json'},
  );
  final doctorRepository =
      DoctorRepository(httpService, resultService: resultService);
  final drugRepository =
      DrugRepository(httpService, resultService: resultService);

  final authService =
      AuthenticationRepository(httpService, resultService: resultService);
  runApp(await builder(
    drugRepository,
    doctorRepository,
    networkInfo,
    httpService,
    authService,
  ));
}
