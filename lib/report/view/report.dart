import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/l10n/l10n.dart';
import 'package:med_mate/report/report.dart';
import 'package:med_mate/report/widget/widget.dart';
import 'package:med_mate/widgets/widget.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportView();
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
          BlocSelector<ReportCubit, ReportState, List<ReportData>>(
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
            const DrawHorizontalLine(),
            const SizedBox(
              height: AppSpacing.xs,
            ),
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
              height: AppSpacing.md,
            ),
            const DrawHorizontalLine(),
            const SizedBox(
              height: AppSpacing.xs,
            ),
            Row(
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
