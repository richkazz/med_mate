import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/app/app.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/report/report.dart';
import 'package:med_mate/report/widget/widget.dart';
import 'package:med_mate/widgets/widget.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    context.read<ReportCubit>().onOpen(
          context.read<AppBloc>().state.user.uid,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ReportCubitListener(child: ReportView());
  }
}

class ReportCubitListener extends StatelessWidget {
  const ReportCubitListener({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state.formSubmissionStateEnum.isSuccessful) {
          AppNotify.dismissNotify();
        } else if (state.formSubmissionStateEnum.isServerFailure) {
          AppNotify.showError(errorMessage: state.errorMessage);
        } else if (state.formSubmissionStateEnum.isInProgress) {
          AppNotify.showLoading();
        }
      },
      child: child,
    );
  }
}

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.reports,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: AppColors.dividerColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Assets.icons.notification02.svg(package: 'app_ui'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(0, AppSpacing.xs, AppSpacing.md, 0),
            child: ReportDateRangeCallButtonSheetButton(l10n: l10n),
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          Expanded(
            child: BlocSelector<ReportCubit, ReportState, List<ReportData>>(
              selector: (state) => state.reportDataList,
              builder: (context, reportDataList) {
                return switch (reportDataList.isEmpty) {
                  true => const NoReportAvailable(),
                  false => ReportDataAvailable(
                      reportDataList: reportDataList,
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReportDateRangeCallButtonSheetButton extends StatelessWidget {
  const ReportDateRangeCallButtonSheetButton({
    required this.l10n,
    super.key,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: AppButton.smallTransparentWithDullBorder(
        onPressed: () async {
          await _showModalBottomSheetForReport(
            context,
            context.read<ReportCubit>(),
          );
        },
        child: BlocBuilder<ReportCubit, ReportState>(
          buildWhen: (previous, current) {
            return current.reportEnum.isReportForChooseASpecificTime ||
                current.reportEnum.isReportForLastMonth ||
                current.reportEnum.isReportForThisMonth;
          },
          builder: (context, state) {
            final text = switch (state.reportEnum) {
              ReportEnum.reportForThisMonth => l10n.thisMonth,
              ReportEnum.reportForLastMonth => l10n.lastMonth,
              ReportEnum.reportForChooseASpecificTime => 'Custom',
              _ => l10n.thisMonth
            };
            return Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w500),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _showModalBottomSheetForReport(
  BuildContext context,
  ReportCubit reportCubit,
) async {
  await showModalBottomSheet<void>(
    backgroundColor: AppColors.white,
    elevation: 0,
    context: context,
    builder: (context) {
      return ReportModalBottomSheetContent(
        reportCubit: reportCubit,
      );
    },
  );
}

class ReportModalBottomSheetContent extends StatelessWidget {
  const ReportModalBottomSheetContent({
    required this.reportCubit,
    super.key,
  });
  final ReportCubit reportCubit;
  @override
  Widget build(BuildContext context) {
    final reportEnum = reportCubit.state.reportEnum;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.selectReportTime,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w300,
                          color: AppColors.textDullColor,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5, top: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CustomPaint(
                      painter: CirclePainter(
                        filled: true,
                        color: AppColors.textFieldFillColor,
                        radius: 10,
                        strokeWidth: 0,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppSpacing.md,
            ),
            ReportSelectedRange(
              isSelected: reportEnum.isReportForThisMonth,
              children: [
                TextButton(
                  onPressed: () {
                    reportCubit.showReportThisMonth();
                    Navigator.pop(context);
                  },
                  child: Text(
                    context.l10n.thisMonth,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                if (reportEnum.isReportForChooseASpecificTime)
                  const DrawHorizontalLine(),
              ],
            ),
            const SizedBox(
              height: AppSpacing.xs,
            ),
            ReportSelectedRange(
              isSelected: reportEnum.isReportForLastMonth,
              children: [
                TextButton(
                  onPressed: () {
                    reportCubit.showReportLastMonth();
                    Navigator.pop(context);
                  },
                  child: Text(
                    context.l10n.lastMonth,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                if (reportEnum.isReportForChooseASpecificTime)
                  const DrawHorizontalLine(),
              ],
            ),
            const SizedBox(
              height: AppSpacing.xs,
            ),
            DecoratedBox(
              decoration: reportEnum.isReportForChooseASpecificTime
                  ? BoxDecoration(
                      border: Border.all(color: AppColors.borderColor),
                      borderRadius: BorderRadius.circular(5),
                    )
                  : const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: null,
                    child: Text(
                      context.l10n.chooseSpecificTime,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final dateTimeRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                      );
                      if (dateTimeRange.isNotNull) {
                        unawaited(
                          reportCubit.showReportCustomRange(dateTimeRange!),
                        );
                      }
                    },
                    icon: Assets.icons.calendar03
                        .svg(package: 'app_ui', width: 15, height: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ),
            Align(
              child: SizedBox(
                width: 200,
                height: 36,
                child: AppButton.primary(
                  borderRadius: 20,
                  onPressed: () {},
                  child: AppButtonText(
                    text: context.l10n.saveAndConfirm,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: AppSpacing.xlg,
            ),
          ],
        ),
      ),
    );
  }
}

class ReportSelectedRange extends StatelessWidget {
  const ReportSelectedRange({
    super.key,
    required this.children,
    required this.isSelected,
  });
  final List<Widget> children;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(5),
            )
          : const BoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          if (isSelected)
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.md),
              child: Icon(Icons.check_circle, color: AppColors.primaryColor),
            ),
        ],
      ),
    );
  }
}
