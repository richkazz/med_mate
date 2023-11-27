import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:domain/domain.dart';
import 'package:flutter/widgets.dart';
import 'package:med_mate/application/application.dart';

/// Observes the state changes and errors in BLoCs and logs them.
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

/// Bootstraps the application with necessary services and configurations.
///
/// [builder] is a function that takes various repositories and services
/// as parameters
/// and returns the root widget of the application.
Future<void> bootstrap(
  FutureOr<Widget> Function(
    DrugRepository drugRepository,
    DoctorRepository doctorRepository,
    NetworkInfoImpl networkInfoImpl,
    HttpService httpService,
    NotificationService notificationService,
    AuthenticationRepository authenticationRepository,
  ) builder,
) async {
  // Ensure the Flutter app is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Handle errors by logging them.
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // Use the custom BLoC observer for logging state changes and errors.
  Bloc.observer = const AppBlocObserver();

  // Create instances of essential services and repositories.
  final resultService = ResultService();
  final notificationService = NotificationService();
  final dataConnectionChecker = DataConnectionChecker();
  final networkInfo = NetworkInfoImpl(dataConnectionChecker);
  final tokenValueNotifier = ValueNotifier<String>('');
  final httpService = DioHttpService(
    networkInfo: networkInfo,
    tokenValueNotifier: tokenValueNotifier,
    baseUrl: 'https://medmatebackend2-production.up.railway.app/api/v1/',
    headers: {'Content-Type': 'application/json'},
  );
  final doctorRepository =
      DoctorRepository(httpService, resultService: resultService);
  final drugRepository =
      DrugRepository(httpService, resultService: resultService);
  final authService = AuthenticationRepository(
    httpService,
    resultService: resultService,
    tokenValueNotifier: tokenValueNotifier,
  );

  // Run the application using the provided builder function.
  runApp(
    await builder(
      drugRepository,
      doctorRepository,
      networkInfo,
      httpService,
      notificationService,
      authService,
    ),
  );
}
