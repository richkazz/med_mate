import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:med_mate/l10n/l10n.dart';
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: AppButton.smallTransparentWithDullBorder(
                  onPressed: () async {
                    await showModalBottomSheet<void>(
                      backgroundColor: AppColors.white,
                      elevation: 0,
                      context: context,
                      builder: (context) {
                        return const ReportModalBottomSheetContent();
                      },
                    );
                  },
                  child: Text(
                    l10n.thisMonth,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Assets.images.medicineCuate1.image(package: 'app_ui'),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportModalBottomSheetContent extends StatelessWidget {
  const ReportModalBottomSheetContent({
    super.key,
  });

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
              onPressed: () {},
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
              onPressed: () {},
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
                  onPressed: () {},
                  child: Text(
                    context.l10n.chooseSpecificTime,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
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

class AppButtonText extends StatelessWidget {
  const AppButtonText({required this.text, required this.color, super.key});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: color,
            fontWeight: FontWeight.w400,
          ),
    );
  }
}

class DrawHorizontalLine extends StatelessWidget {
  const DrawHorizontalLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.dividerColor,
    );
  }
}
