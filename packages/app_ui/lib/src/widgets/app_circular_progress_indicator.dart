import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

///
class AppCircularProgressIndicatorFilledWhiteSmall extends StatelessWidget {
  ///
  const AppCircularProgressIndicatorFilledWhiteSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 25, maxHeight: 30),
      child: const CircularProgressIndicator(
        color: AppColors.black,
        backgroundColor: AppColors.white,
      ),
    );
  }
}
