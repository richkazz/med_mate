import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/widget/widgets.dart';
import 'package:med_mate/widgets/widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final drugs = context
        .select<LandingPageCubit, List<Drug>>((value) => value.state.drugs);
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.outlineLight,
          ),
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
                  onPressed: () {
                    context.read<LandingPageCubit>().showCalenderToSelect();
                  },
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
      body: SingleChildScrollView(
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
            const AddMedicationButton(),
            const SizedBox(
              height: AppSpacing.lg,
            ),
          ],
        ),
      ),
    );
  }
}
