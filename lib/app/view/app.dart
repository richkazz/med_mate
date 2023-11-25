import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';

class App extends StatelessWidget {
  const App({
    required User user,
    required this.drugRepository,
    required this.networkInfoImpl,
    required this.httpService,
    required this.authenticationRepository,
    super.key,
  }) : _user = user;

  final User _user;
  final DrugRepository drugRepository;
  final NetworkInfoImpl networkInfoImpl;
  final HttpService httpService;
  final AuthenticationRepository authenticationRepository;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DrugRepository>(
          create: (context) => drugRepository,
        ),
        RepositoryProvider<NetworkInfoImpl>(
          create: (context) => networkInfoImpl,
        ),
        RepositoryProvider<HttpService>(
          create: (context) => httpService,
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => authenticationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              user: _user,
            )..add(const AppOpened()),
          ),
          BlocProvider(
            create: (_) => LandingPageCubit(drugRepository),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: const AppTheme().themeData,
      darkTheme: const AppDarkTheme().themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Stack(
        children: [
          AuthenticatedUserListener(
            child: FlowBuilder<AppStatus>(
              state: context.select((AppBloc bloc) => bloc.state.status),
              onGeneratePages: onGenerateAppViewPages,
            ),
          ),
          const LoadingContent(),
        ],
      ),
    );
  }
}
