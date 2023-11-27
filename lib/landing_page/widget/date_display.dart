import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:med_mate/landing_page/cubit/landing_page_cubit.dart';

import 'package:med_mate/landing_page/cubit/landing_page_state.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            weekDayName,
            style: theme.textTheme.bodySmall!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            icon: CircleAvatar(
              radius: 19,
              backgroundColor: AppColors.textFieldFillColor,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: isSelected
                    ? AppColors.primaryColor
                    : AppColors.textFieldFillColor,
                child: CircleAvatar(
                  radius: 15,
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
      ),
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
    _init();
    super.initState();
  }

  void _init() {
    _selectedDate = DateTime.now();
    _today = DateTime.now();

    // Set initial page to today's date
    _pageController = PageController(
      initialPage:
          max(_today.day - 1, 8), // Ensure at least 8 pages are visible
      viewportFraction: 0.14, // Adjust the fraction of the viewport
    );
  }

  @override
  void reassemble() {
    _init();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    final monthLength = getDaysInEachMonth(_selectedDate.year);
    return BlocListener<LandingPageBloc, LandingPageState>(
      listenWhen: (previous, current) =>
          current.landingPageEnum.isCalenderSelect,
      listener: (context, state) {
        _showDatePicker(context);
      },
      child: SizedBox(
        height: 80,
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: monthLength[_selectedDate.month],
          itemBuilder: (context, index) {
            final day = index + 1;
            return _buildDayCircle(day);
          },
        ),
      ),
    );
  }

  DateTime _getDate(int day) {
    // Assuming that it's the current month
    return DateTime(_selectedDate.year, _selectedDate.month, day);
  }

  Widget _buildDayCircle(int day) {
    final isSelectedDate = day == _selectedDate.day;
    return WeekDayItem(
      isSelected: isSelectedDate,
      onPressed: () {},
      weekDayName: getDayOfWeek(_getDate(day)),
      weekDayNumber: day,
    );
  }

  String getDayOfWeek(DateTime date) {
    final formatter = DateFormat('EEE');
    return formatter.format(date);
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
        _pageController.jumpToPage(max(_selectedDate.day - 1, 3));
      });
    }
  }
}

Map<int, int> getDaysInEachMonth(int year) {
  final daysInEachMonth = <int, int>{};

  for (var month = 1; month <= 12; month++) {
    final date = DateTime(year, month + 1, 0);
    daysInEachMonth[month] = date.day;
  }

  return daysInEachMonth;
}
