import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/application/application.dart';
import 'package:med_mate/doctor/cubit/add_doctor_cubit.dart';
import 'package:med_mate/doctor/doctor.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/util/helper.dart';
import 'package:med_mate/widgets/widget.dart';

class AddDoctorPage extends StatelessWidget {
  const AddDoctorPage({super.key});
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const AddDoctorPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddDoctorCubit(context.read<DoctorRepository>()),
      child: const AddDoctorView(),
    );
  }
}

class AddDoctorBlocListener extends StatelessWidget {
  const AddDoctorBlocListener({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AddDoctorCubit, AddDoctorState>(
      listener: (context, state) {
        if (state.submissionStateEnum.isSuccessful) {
          AppNotify.dismissNotify();
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            SlidePageRoute<DoctorPage>(
              page: const DoctorPage(
                key: ValueKey<String>('DoctorPage'),
              ),
            ),
          );
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

class AddDoctorView extends StatelessWidget {
  const AddDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithTitleText(title: context.l10n.addDoctor),
      body: AddDoctorBlocListener(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  SizedBox(
                    height: AppSpacing.xxlg,
                  ),
                  AddDoctorForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddDoctorForm extends StatefulWidget {
  const AddDoctorForm({super.key});

  @override
  State<AddDoctorForm> createState() => _AddDoctorFormState();
}

class _AddDoctorFormState extends State<AddDoctorForm> {
  final globalFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalFormKey,
      child: Column(
        children: [
          AppTextFieldOutlined(
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(
              Icons.email_outlined,
              color: AppColors.fieldBorderColor,
            ),
            hintText: context.l10n.doctorsName,
            validator: (val) => validateEmail(val, context.l10n.email),
          ),
          const SizedBox(
            height: AppSpacing.xxlg,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 37),
            child: AppButton.primary(
              borderRadius: 25,
              onPressed: () {
                if (globalFormKey.currentState!.validate()) {
                  context.read<AddDoctorCubit>().submit(emailController.text);
                }
              },
              child: AppButtonText(
                color: AppColors.white,
                text: context.l10n.saveAndConfirm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
