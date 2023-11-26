import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/login/cubit/login_cubit.dart';
import 'package:med_mate/signup/sign_up.dart';
import 'package:med_mate/util/helper.dart';
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
                      SlidePageRoute<SignUpPage>(
                        page: const SignUpPage(
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
              //AppNotify.showError(errorMessage: state.errorMessage);
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

class TextFormFieldS extends StatefulWidget {
  const TextFormFieldS({super.key});

  @override
  State<TextFormFieldS> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends State<TextFormFieldS> {
  final globalFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: globalFormKey,
      child: Column(
        children: [
          TextFieldItem(
            textInputType: TextInputType.emailAddress,
            controller: emailController,
            validator: (val) {
              return validateEmail(val, l10n.email);
            },
            title: l10n.email,
          ),
          TextFieldItem(
            textInputType: TextInputType.visiblePassword,
            controller: passwordController,
            obscureText: true,
            validator: (val) {
              return validatePassword(val, l10n.passwordErrorText);
            },
            title: l10n.password,
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          AppButton.primary(
            onPressed: () {
              if (globalFormKey.currentState!.validate()) {
                final login = Login(
                  email: emailController.text,
                  password: passwordController.text,
                );
                context.read<LoginCubit>().submit(login);
              }
            },
            borderRadius: 25,
            child: AppButtonText(
              color: AppColors.white,
              text: l10n.continueText,
            ),
          ),
        ],
      ),
    );
  }
}

typedef Validator = String? Function(String?);

class TextFieldItem extends StatelessWidget {
  const TextFieldItem({
    required this.title,
    required this.validator,
    required this.controller,
    required this.textInputType,
    this.obscureText = false,
    super.key,
  });
  final String title;
  final Validator validator;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType textInputType;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: AppColors.textDullColor,
              ),
        ),
        const SizedBox(
          height: AppSpacing.sm,
        ),
        AppTextFieldOutlined(
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          keyboardType: textInputType,
        ),
      ],
    );
  }
}
