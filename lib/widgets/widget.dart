import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class IconWithRoundedBackground extends StatelessWidget {
  const IconWithRoundedBackground({
    required this.icon,
    required this.color,
    super.key,
  });
  final Widget icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: icon,
    );
  }
}

class DecoratedBoxWithPrimaryBorder extends StatelessWidget {
  const DecoratedBoxWithPrimaryBorder({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: child);
  }
}
