import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/home/home.dart';
import 'package:med_mate/report/report.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ReportCubit()),
      ],
      child: const HomeView(),
    );
  }
}
