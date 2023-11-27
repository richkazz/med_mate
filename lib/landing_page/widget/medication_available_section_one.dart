import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';
import 'package:med_mate/landing_page/cubit/landing_page_state.dart';
import 'package:med_mate/landing_page/widget/widgets.dart';
import 'package:med_mate/widgets/widget.dart';

class MedicationAvailableSectionOne extends StatelessWidget {
  const MedicationAvailableSectionOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(
        color: AppColors.bottomNavBarColor,
        radius: 100,
      ),
      child: CustomPaint(
        painter:
            CirclePainter(color: AppColors.white, radius: 90, filled: true),
        child: CustomPaint(
          painter: CirclePainter(
            color: AppColors.primaryColor,
            radius: 86,
            filled: true,
          ),
          child: Column(
            children: [
              Text(
                'Next dose in',
                style: ContentTextStyle.bodyText2.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              const NextDosageTimeAndButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class NextDosageTimeAndButton extends StatelessWidget {
  const NextDosageTimeAndButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingPageBloc, LandingPageState>(
      buildWhen: (previous, current) =>
          current.nextDosageTime != previous.nextDosageTime,
      builder: (context, state) {
        final (duration, drug, indexOfDosageTime) = state.nextDosageTime;
        final detailController = DrugDetailController(
          context: context,
          drug: drug,
          indexOfDosageTime: indexOfDosageTime,
        );
        return Column(
          children: [
            Text(
              indexOfDosageTime == -1 || formatDuration(duration).isEmpty
                  ? '__/__'
                  : formatDuration(duration),
              style: ContentTextStyle.headline5.copyWith(
                color: AppColors.white,
              ),
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            SizedBox(
              width: 90,
              height: 35,
              child: AppButton.primaryFilledWhite(
                onPressed:
                    indexOfDosageTime == -1 || formatDuration(duration).isEmpty
                        ? null
                        : () {
                            detailController.onDoneButtonClicked(
                              context.read<LandingPageBloc>(),
                              Theme.of(context),
                            );
                          },
                borderRadius: 25,
                child: Text(
                  'Take now',
                  style: ContentTextStyle.labelSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

String formatDuration(Duration duration) {
  // Handle invalid durations
  if (duration.isNegative) {
    throw ArgumentError('Invalid duration: $duration');
  }

  // Extract hours, minutes, and seconds
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;

  // Build the formatted string
  final formattedString = StringBuffer();

  // Add hours if applicable
  if (hours > 0) {
    formattedString.write('$hours hours');

    // Add a comma if there are minutes or seconds
    if (minutes > 0 || seconds > 0) {
      formattedString.write(', ');
    }
  }

  // Add minutes if applicable
  if (minutes > 0) {
    formattedString.write('$minutes minutes');

    // Add a space if there are seconds
    if (seconds > 0) {
      formattedString.write(' ');
    }
  }

  // Add seconds if applicable
  if (seconds > 0) {
    formattedString.write('$seconds seconds');
  }

  return formattedString.toString();
}
