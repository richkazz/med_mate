import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/login/cubit/login_cubit.dart';
import 'package:med_mate/signup/sign_up.dart';
import 'package:med_mate/util/helper.dart';
import 'package:med_mate/widgets/widget.dart';

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
