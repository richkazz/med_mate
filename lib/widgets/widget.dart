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
