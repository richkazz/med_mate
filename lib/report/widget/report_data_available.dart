import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_mate/report/report.dart';
import 'package:med_mate/widgets/widget.dart';

class ReportDataAvailable extends StatelessWidget {
  const ReportDataAvailable({required this.reportDataList, super.key});
  final List<ReportData> reportDataList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == reportDataList.length - 1) {
          return Column(
            children: [
              DrugReportItem(
                reportData: reportDataList[index],
              ),
              const SizedBox(
                height: AppSpacing.xlg,
              ),
              const AddMedicationButton(),
            ],
          );
        }
        return DrugReportItem(
          reportData: reportDataList[index],
        );
      },
      itemCount: reportDataList.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: AppSpacing.md,
        );
      },
    );
  }
}

class DrugReportItem extends StatelessWidget {
  const DrugReportItem({required this.reportData, super.key});
  final ReportData reportData;
  @override
  Widget build(BuildContext context) {
    String formatDateToMonthDay(DateTime dateTime) {
      final formatter = DateFormat('EEEE, MMMM d');
      return formatter.format(dateTime);
    }

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: ColoredBox(
        color: AppColors.bottomNavBarColor,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDateToMonthDay(reportData.date),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              ReportDataItemStatusCount(
                count: reportData.numberOfDrugTaken,
                icon: const Icon(
                  Icons.check_circle,
                  color: AppColors.green,
                  size: 14,
                ),
                text: 'Taken',
              ),
              ReportDataItemStatusCount(
                count: reportData.numberOfDrugMissed,
                icon: const CircleAvatar(
                  backgroundColor: AppColors.red,
                  radius: 6,
                  child: Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 7,
                  ),
                ),
                text: 'Missed',
              ),
              ReportDataItemStatusCount(
                count: reportData.numberOfDrugSkipped,
                icon: const CircleAvatar(
                  backgroundColor: AppColors.orange,
                  radius: 6,
                  child: Icon(
                    Icons.shuffle_outlined,
                    color: AppColors.white,
                    size: 7,
                  ),
                ),
                text: 'Skipped',
                isLineSeparatorVisible: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportDataItemStatusCount extends StatelessWidget {
  const ReportDataItemStatusCount({
    required this.icon,
    required this.text,
    required this.count,
    this.isLineSeparatorVisible = true,
    super.key,
  });
  final Widget icon;
  final String text;
  final int count;
  final bool isLineSeparatorVisible;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLineSeparatorVisible)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 15,
                child: icon,
              ),
              const Text('|'),
            ],
          )
        else
          SizedBox(
            width: 15,
            child: icon,
          ),
        const SizedBox(
          width: AppSpacing.md,
        ),
        Text(
          '$text ',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          '($count)',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
