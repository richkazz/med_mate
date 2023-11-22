import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

///Set the boxdecoration
class AppBoxDecoration {
  ///A large box decoration
  static BoxDecoration largeBoxDecoration(
    Brightness brightness, {
    double borderRadius = 20,
  }) {
    return BoxDecoration(
      color: brightness == Brightness.light ? AppColors.whiteCardField : null,
      boxShadow: [
        BoxShadow(
          color: brightness == Brightness.light
              ? AppColors.boxShadow
              : AppColors.black,
          blurRadius: 2,
          spreadRadius: 1,
          offset: const Offset(0, 1),
        )
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(
          borderRadius,
        ), //                 <--- border radius here
      ),
    );
  }
}
