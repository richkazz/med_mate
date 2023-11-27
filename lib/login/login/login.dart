import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/login/cubit/login_cubit.dart';
import 'package:med_mate/login/widgets/login_bloc_listener.dart';
import 'package:med_mate/login/widgets/text_form_field_s.dart';
import 'package:med_mate/signup/sign_up.dart' as sign_up;
import 'package:med_mate/widgets/widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthenticationRepository>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: LoginBlocListener(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.createAccount,
                      style: theme.textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.textFieldFillColor,
                        child: Icon(
                          Icons.close,
                          color: AppColors.black,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const TextFormFieldS(),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                AuthHelperActionText(
                  action: 'Sign Up',
                  question: "Don't have an account?",
                  onPressed: () {
                    Navigator.of(context).push(
                      SlidePageRoute<sign_up.SignUpPage>(
                        page: const sign_up.SignUpPage(
                          key: ValueKey<String>('SignUpPage'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
