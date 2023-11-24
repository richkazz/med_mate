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
      child: child,
    );
  }
}

class DecoratedBoxWithFailureBorder extends StatelessWidget {
  const DecoratedBoxWithFailureBorder({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBoxWithColorBorderContent(
      color: AppColors.red,
      icon: Icons.close,
      child: child,
    );
  }
}

class DecoratedBoxWithSuccessBorder extends StatelessWidget {
  const DecoratedBoxWithSuccessBorder({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBoxWithColorBorderContent(
      color: AppColors.green,
      icon: Icons.check,
      child: child,
    );
  }
}

class DecoratedBoxWithSkippedBorder extends StatelessWidget {
  const DecoratedBoxWithSkippedBorder({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBoxWithColorBorderContent(
      color: AppColors.orange,
      icon: Icons.shuffle_outlined,
      child: child,
    );
  }
}

class DecoratedBoxWithColorBorderContent extends StatelessWidget {
  const DecoratedBoxWithColorBorderContent({
    required this.child,
    required this.color,
    required this.icon,
    super.key,
  });

  final Widget child;
  final Color color;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(15),
            ),
            child: child,
          ),
        ),
        Positioned(
          right: 0,
          child: CircleAvatar(
            radius: 9,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.radius,
    required this.color,
    this.filled = false,
    this.strokeWidth = 4.0,
  });
  final double radius;
  final bool filled;
  final Color color;
  final double strokeWidth;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = filled ? 0 : strokeWidth;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
