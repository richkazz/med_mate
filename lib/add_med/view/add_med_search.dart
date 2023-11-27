import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:med_mate/add_med/cubit/add_med_cubit.dart';
import 'package:med_mate/add_med/widget/widget.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/widgets/widget.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final addMedicationFormType =
        context.select<AddMedicationCubit, AddMedicationFormType>(
      (value) => value.state.addMedicationFormType,
    );
    final formTypeWidget = switch (addMedicationFormType) {
      AddMedicationFormType.search => const SearchContent(),
      AddMedicationFormType.selectOne => const SearchContent(),
      AddMedicationFormType.timePicker =>
        const TimePickerContentPickerContent(),
      AddMedicationFormType.datePicker => const DatePickerContent(),
    };

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150, maxHeight: 300),
      child: DecoratedBoxWithPrimaryBorder(
        child: Padding(
          padding: addMedicationFormType.isTimePicker
              ? EdgeInsets.zero
              : const EdgeInsets.all(AppSpacing.md),
          child: formTypeWidget,
        ),
      ),
    );
  }
}

class DatePickerContent extends StatefulWidget {
  const DatePickerContent({super.key});

  @override
  State<DatePickerContent> createState() => _DatePickerContentState();
}

class _DatePickerContentState extends State<DatePickerContent> {
  DateTime? _startDate;
  DateTime? _endDate;
  Future<void> _selectTime(BuildContext context) async {
    final dateRange = await showDateRangePicker(
      context: context,
      lastDate: DateTime.utc(2030),
      firstDate: DateTime.now(),
    );
    if (dateRange != null) {
      setState(() {
        _startDate = dateRange.start;
        _endDate = dateRange.end;
        context.read<AddMedicationCubit>().onDateTimeSelected(dateRange);
      });
    }
  }

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('MMMM d, yyyy'); // Configure the date format
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    final formattedStartDate =
        formatDate(_startDate.isNull ? time : _startDate!);
    final formattedEndDate = formatDate(_endDate.isNull ? time : _endDate!);
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () async {
                await _selectTime(context);
              },
              icon: const Icon(
                Icons.access_time_outlined,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _startDate.isNull ? '' : 'Start: $formattedStartDate',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    _endDate.isNull ? '' : 'End: $formattedEndDate',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddMedicationInheritedWidget extends InheritedWidget {
  const AddMedicationInheritedWidget({
    required super.child,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.stepNumber,
    required this.stepTotalCount,
    required this.onNextClicked,
    required this.formList,
    required this.initialValue,
    required this.onAppBarBackButtonPressed,
    required this.onPreviousButtonPressed,
    required this.selectedDrugName,
    required this.drug,
    this.isSearchTextFieldVisible = true,
    super.key,
  });
  final String title;
  final String subTitle;
  final Drug drug;
  final String? selectedDrugName;
  final List<String> formList;
  final String initialValue;
  final bool isSearchTextFieldVisible;
  final Widget icon;
  final int stepNumber;
  final int stepTotalCount;
  final ValueChanged<Object> onNextClicked;
  final VoidCallback onAppBarBackButtonPressed;
  final VoidCallback onPreviousButtonPressed;
  static AddMedicationInheritedWidget? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AddMedicationInheritedWidget>();
  }

  static AddMedicationInheritedWidget of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AddMedicationInheritedWidget oldWidget) {
    return false;
  }
}

class AddMedicationSteps extends StatelessWidget {
  const AddMedicationSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final addMedicationAttribute = AddMedicationInheritedWidget.of(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 45,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: AppBackButton.light(
            onPressed: AddMedicationInheritedWidget.of(context)
                .onAppBarBackButtonPressed,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Steps ${AddMedicationInheritedWidget.of(context).stepNumber} '
          'of ${AddMedicationInheritedWidget.of(context).stepTotalCount}',
          style: theme.textTheme.labelSmall
              ?.copyWith(color: const Color.fromRGBO(97, 97, 97, 1)),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                Container(
                  height: 1,
                  color: AppColors.dividerColor,
                ),
                const FoldIfKeyboardVisible(),
                const SectionTwo(),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (addMedicationAttribute.stepNumber == 1)
                      const SizedBox()
                    else
                      PreviousButton(
                        l10n: l10n,
                        onPressed:
                            addMedicationAttribute.onPreviousButtonPressed,
                      ),
                    NextButton(
                      l10n: l10n,
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoldIfKeyboardVisible extends StatelessWidget {
  const FoldIfKeyboardVisible({super.key});

  @override
  Widget build(BuildContext context) {
    final addMedicationAttribute = AddMedicationInheritedWidget.of(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: AppSpacing.md,
        ),
        if (addMedicationAttribute.selectedDrugName.isNotNullOrWhiteSpace)
          Text(
            addMedicationAttribute.selectedDrugName!,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: AppColors.textDullColor),
          ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        IconWithRoundedBackground(
          color: AppColors.icon2BackgroundColor,
          icon: addMedicationAttribute.icon,
        ),
        const SizedBox(
          height: AppSpacing.lg,
        ),
        SectionOne(
          title: addMedicationAttribute.title,
          subTitle: addMedicationAttribute.subTitle,
        ),
      ],
    );
  }
}

class SectionOne extends StatelessWidget {
  const SectionOne({required this.title, required this.subTitle, super.key});
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          title,
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
              subTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall!.copyWith(
                color: AppColors.textDullColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchContent extends StatelessWidget {
  const SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (AddMedicationInheritedWidget.of(context).isSearchTextFieldVisible)
          BlocSelector<AddMedicationCubit, SearchTextFieldState, String>(
            selector: (state) => state.initialValue,
            builder: (context, initialValue) {
              return AppTextField(
                initialValue: initialValue,
                borderRadiusCircularSize: 5,
                onChanged: (value) {
                  context.read<AddMedicationCubit>().search(value);
                },
              );
            },
          ),
        const SizedBox(
          height: AppSpacing.md,
        ),
        BlocBuilder<AddMedicationCubit, SearchTextFieldState>(
          builder: (context, state) {
            return state.list.isEmpty
                ? const SizedBox()
                : Container(
                    height: 1,
                    color: AppColors.dividerColor,
                  );
          },
        ),
        Expanded(
          child: BlocBuilder<AddMedicationCubit, SearchTextFieldState>(
            builder: (context, state) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return SearchItem(
                    index: index,
                    searchableValue: state.list[index],
                    isSelected: index == state.selectedIndex,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    color: AppColors.dividerColor,
                  );
                },
                itemCount: state.list.length,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SearchItem extends StatelessWidget {
  const SearchItem({
    required this.searchableValue,
    required this.isSelected,
    required this.index,
    super.key,
  });
  final String searchableValue;
  final bool isSelected;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<AddMedicationCubit>().onSearchItemSelected(index);
      },
      child: DecoratedBox(
        decoration: isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primaryColor),
              )
            : const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xlg,
            right: AppSpacing.xlg,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.sizeOf(context).width,
              minHeight: 46,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    searchableValue,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
