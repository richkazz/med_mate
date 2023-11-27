import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/add_med/view/add_med.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/cubit/landing_page_state.dart';
import 'package:med_mate/landing_page/widget/widgets.dart';
import 'package:med_mate/widgets/widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<LandingPageBloc>()
        .add(GetDrugsByUserId(userId: context.read<AppBloc>().state.user.uid));
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<LandingPageBloc, LandingPageState>(
        builder: (context, state) {
          if (state.drugs.isEmpty) {
            return const SizedBox();
          }
          return IconButton(
            onPressed: () {
              Navigator.push(context, AddMedication.route());
            },
            icon: const CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.add,
                size: 30,
                color: AppColors.white,
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Assets.images.boyFaceProfile.image(package: 'app_ui'),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Michael',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 15,
              ),
            ),
          ],
        ),
        actions: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Nov'),
                IconButton(
                  onPressed: null,
                  icon: Assets.icons.calendar03.svg(
                    height: 20,
                    width: 20,
                    package: 'app_ui',
                    colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(172, 172, 172, 1),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Assets.icons.notification02.svg(package: 'app_ui'),
          ),
        ],
      ),
      body: BlocBuilder<LandingPageBloc, LandingPageState>(
        buildWhen: (previous, current) {
          return current.submissionStateEnum != previous.submissionStateEnum;
        },
        builder: (context, state) {
          if (state.submissionStateEnum.isInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.submissionStateEnum.isServerFailure) {
            context.read<LandingPageBloc>().add(
                  GetDrugsByUserId(
                    userId: context.read<AppBloc>().state.user.uid,
                  ),
                );
            AppNotify.showError(errorMessage: state.errorMessage);
            return const Center(
              child: SizedBox(
                width: 200,
                height: 36,
                child: AppButton.primary(
                  child: AppButtonText(
                    color: AppColors.white,
                    text: 'Retry',
                  ),
                ),
              ),
            );
          }

          return const LandingPageView();
        },
      ),
    );
  }
}

class LandingPageView extends StatelessWidget {
  const LandingPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final drugs = context
        .select<LandingPageBloc, List<Drug>>((value) => value.state.drugs);
    return SingleChildScrollView(
      child: Column(
        children: [
          const Divider(
            color: AppColors.dividerColor,
          ),
          const DateSelector(),
          if (drugs.isEmpty)
            const NoMedicationAvailable(
              key: ValueKey('NoMedicationAvailable'),
            )
          else
            const MedicationAvailable(
              key: ValueKey('MedicationAvailable'),
            ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          if (drugs.isEmpty) const AddMedicationButton(),
          const SizedBox(
            height: AppSpacing.lg,
          ),
        ],
      ),
    );
  }
}
