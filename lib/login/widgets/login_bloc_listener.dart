import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/login/cubit/login_cubit.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.submissionStateEnum.isSuccessful) {
              //
            } else if (state.submissionStateEnum.isInProgress) {
              AppNotify.showLoading();
            } else if (state.submissionStateEnum.isServerFailure) {
              AppNotify.showError(errorMessage: state.errorMessage);
            }
          },
        ),
        BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state.status.isLoggedIn) {
              AppNotify.dismissNotify();
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          child: Container(),
        )
      ],
      child: child,
    );
  }
}
