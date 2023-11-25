import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/signup/cubit/sign_up_cubit.dart';
import 'package:med_mate/widgets/widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignUpCubit(context.read<AuthenticationRepository>()),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      body: SignUpBlocListener(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpBlocListener extends StatelessWidget {
  const SignUpBlocListener({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.submissionStateEnum.isSuccessful) {
          //
        } else if (state.submissionStateEnum.isInProgress) {
          AppNotify.showLoading();
        } else if (state.submissionStateEnum.isServerFailure) {
          AppNotify.showError(errorMessage: state.errorMessage);
        }
      },
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
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: globalFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFieldItem(
                  textInputType: TextInputType.text,
                  controller: firstNameController,
                  validator: (val) {
                    return _validateName(val, l10n.firstName);
                  },
                  title: l10n.firstName,
                ),
              ),
              const SizedBox(
                width: AppSpacing.md,
              ),
              Expanded(
                child: TextFieldItem(
                  textInputType: TextInputType.text,
                  controller: lastNameController,
                  validator: (val) {
                    return _validateName(val, l10n.lastName);
                  },
                  title: l10n.lastName,
                ),
              ),
            ],
          ),
          TextFieldItem(
            textInputType: TextInputType.emailAddress,
            controller: emailController,
            validator: (val) {
              return _validateEmail(val, l10n.email);
            },
            title: l10n.email,
          ),
          TextFieldItem(
            textInputType: TextInputType.visiblePassword,
            controller: passwordController,
            obscureText: true,
            validator: (val) {
              return _validatePassword(val, l10n.passwordErrorText);
            },
            title: l10n.password,
          ),
          TextFieldItem(
            textInputType: TextInputType.visiblePassword,
            controller: confirmPasswordController,
            obscureText: true,
            validator: (val) {
              return _validateConfirmPassword(
                passwordController.text,
                confirmPasswordController.text,
              );
            },
            title: l10n.confirmPassword,
          ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          AppButton.primary(
            onPressed: () {
              if (globalFormKey.currentState!.validate()) {
                final signUp = SignUp(
                  firstname: firstNameController.text,
                  lastname: lastNameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                );
                context.read<SignUpCubit>().submit(signUp);
              }
            },
            borderRadius: 25,
            child: AppButtonText(
              color: AppColors.white,
              text: l10n.createAccount,
            ),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? val, String name) {
    if (val.isNullOrWhiteSpace || !nameRegex.hasMatch(val!)) {
      return '$name not valid';
    }
    return null;
  }

  String? _validateEmail(String? val, String name) {
    if (val.isNullOrWhiteSpace || !emailRegex.hasMatch(val!)) {
      return '$name not valid';
    }
    return null;
  }

  String? _validatePassword(String? val, String errorText) {
    if (val.isNullOrWhiteSpace || !passwordRegex.hasMatch(val!)) {
      return 'Password must:\n- Be at least 8 characters long\n- Contain at'
          ' least one uppercase letter\n- Contain at least one '
          'lowercase letter\n-'
          ' Contain at least one digit\n- Contain at least one'
          ' special character'
          r' (!@#$%^&*(),.?":{}|<>)';
    }
    return null;
  }

  String? _validateConfirmPassword(String? password, String? confirmPassword) {
    if (password.isNullOrWhiteSpace ||
        confirmPassword.isNullOrWhiteSpace ||
        password != confirmPassword) {
      return 'Confirm password must match the password';
    }
    return null;
  }
}

RegExp passwordRegex = RegExp(
  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$',
);

RegExp nameRegex = RegExp(r'^[a-zA-Z]+(?: +[a-zA-Z]+)*$');
RegExp emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  caseSensitive: false,
);

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