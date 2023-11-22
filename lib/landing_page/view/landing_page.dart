import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/add_med/add_med.dart';
import 'package:med_mate/l10n/l10n.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: Column(
        children: [
          ContentTitle(theme: theme),
          const Divider(),
          const DateSelector(),
          Assets.images.landingPageToDoIcon.image(package: 'app_ui'),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Text(
            l10n.trackMedicationSchedule,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 230),
              child: Text(
                l10n.medsTakenInstruction,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall!.copyWith(
                  color: AppColors.textDullColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          AddMedicationButton(l10n: l10n),
          const SizedBox(
            height: AppSpacing.lg,
          ),
        ],
      ),
    );
  }
}

class ContentTitle extends StatelessWidget {
  const ContentTitle({
    required this.theme,
    super.key,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.outlineLight,
                ),
                const SizedBox(
                  width: AppSpacing.sm,
                ),
                Text(
                  'Michael',
                  style: theme.textTheme.titleMedium,
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
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Nov'),
                  Assets.icons.calendar03.svg(
                    height: 20,
                    width: 20,
                    package: 'app_ui',
                    colorFilter: const ColorFilter.mode(
                      Color.fromRGBO(172, 172, 172, 1),
                      BlendMode.srcIn,
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
      ),
    );
  }
}

class AddMedicationButton extends StatelessWidget {
  const AddMedicationButton({
    required this.l10n,
    super.key,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250, maxHeight: 40),
        child: AppButton.primary(
          onPressed: () => Navigator.push(context, AddMedication.route()),
          borderRadius: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
              ),
              Text(
                l10n.addMedication,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeekDayItem extends StatelessWidget {
  const WeekDayItem({
    required this.weekDayNumber,
    required this.weekDayName,
    required this.onPressed,
    required this.isSelected,
    super.key,
  });
  final int weekDayNumber;
  final String weekDayName;
  final VoidCallback onPressed;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          weekDayName,
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: CircleAvatar(
            radius: 21,
            backgroundColor: AppColors.textFieldFillColor,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: isSelected
                  ? AppColors.primaryColor
                  : AppColors.textFieldFillColor,
              child: CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.textFieldFillColor,
                child: Center(
                  child: Text(
                    '$weekDayNumber',
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(173, 173, 173, 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late PageController _pageController;
  late DateTime _selectedDate;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _today = DateTime.now();

    // Set initial page to today's date
    _pageController = PageController(
      initialPage:
          max(_today.day - 1, 8), // Ensure at least 8 pages are visible
      viewportFraction: 0.2, // Adjust the fraction of the viewport
    );
  }

//  IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: () => _showDatePicker(context),
//           ),
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final day = index + 1;
          return _buildDayCircle(day);
        },
      ),
    );
  }

  Widget _buildDayCircle(int day) {
    final isToday = day == _today.day;

    return WeekDayItem(
      isSelected: isToday,
      onPressed: () {},
      weekDayName: 'Mon',
      weekDayNumber: day,
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        // Scroll to the selected date
        _pageController.jumpToPage(max(_selectedDate.day - 1, 8));
      });
    }
  }
}
