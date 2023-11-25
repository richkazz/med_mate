import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_button}
/// Button with text displayed in the application.
/// {@endtemplate}
class AppButton extends StatelessWidget {
  /// {@macro app_button}
  const AppButton._({
    required this.child,
    this.onPressed,
    Color? buttonColor,
    Color? disabledButtonColor,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    BorderSide? borderSide,
    double? elevation,
    TextStyle? textStyle,
    Size? maximumSize,
    Size? minimumSize,
    EdgeInsets? padding,
    double borderRadius = 10,
    super.key,
  })  : _buttonColor = buttonColor ?? Colors.white,
        _disabledButtonColor = disabledButtonColor ?? AppColors.disabledButton,
        _borderSide = borderSide,
        _borderRadius = borderRadius,
        _foregroundColor = foregroundColor ?? AppColors.black,
        _disabledForegroundColor =
            disabledForegroundColor ?? AppColors.disabledForeground,
        _elevation = elevation ?? 0,
        _textStyle = textStyle,
        _maximumSize = maximumSize ?? _defaultMaximumSize,
        _minimumSize = minimumSize ?? _defaultMinimumSize,
        _padding = padding ?? _defaultPadding;

  /// filled dark blue button
  const AppButton.primary({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    double? borderRadius,
    Color? color,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          borderRadius: borderRadius ?? 0,
          buttonColor: color ?? AppColors.enabledButtonBackgroundColor,
          elevation: elevation,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white,
          disabledButtonColor: AppColors.disabledButtonBackgroundColor,
          textStyle: textStyle,
          padding: const EdgeInsets.only(
            bottom: AppSpacing.xs,
            top: AppSpacing.xs,
          ),
        );

  /// filled dark blue button
  const AppButton.smallOutlineWithWhiteBorderTransparent({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          borderRadius: 25,
          borderSide: const BorderSide(color: AppColors.white),
          buttonColor: AppColors.transparent,
          elevation: elevation,
          foregroundColor: AppColors.transparent,
          disabledForegroundColor: AppColors.transparent,
          disabledButtonColor: AppColors.transparent,
          textStyle: textStyle,
          padding: const EdgeInsets.only(
            bottom: AppSpacing.xs,
            top: AppSpacing.xs,
          ),
        );

  /// filled dark blue button
  const AppButton.primaryOutlined({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    double? borderRadius,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: borderRadius ?? 0,
          buttonColor: AppColors.white,
          elevation: elevation,
          foregroundColor: AppColors.enabledButtonBackgroundColor,
          disabledForegroundColor: AppColors.disabledButtonBackgroundColor,
          disabledButtonColor: AppColors.white,
          textStyle: textStyle,
          padding: const EdgeInsets.only(
            bottom: AppSpacing.xs,
            top: AppSpacing.xs,
          ),
        );

  /// filled dark blue button
  const AppButton.primaryFilledWhite({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    double? borderRadius,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          borderRadius: borderRadius ?? 0,
          buttonColor: AppColors.white,
          elevation: elevation,
          foregroundColor: AppColors.enabledButtonBackgroundColor,
          disabledForegroundColor: AppColors.disabledButtonBackgroundColor,
          disabledButtonColor: AppColors.white,
          textStyle: textStyle,
          padding: const EdgeInsets.only(
            bottom: AppSpacing.xs,
            top: AppSpacing.xs,
          ),
        );

  /// filled dark blue button
  const AppButton.smallTransparentWithDullBorder({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          borderRadius: 20,
          borderSide: const BorderSide(color: AppColors.dividerColor),
          buttonColor: AppColors.transparent,
          elevation: elevation,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white,
          disabledButtonColor: AppColors.white,
          textStyle: textStyle,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: const EdgeInsets.only(
            bottom: AppSpacing.xs,
            top: AppSpacing.xs,
          ),
        );

  /// The maximum size of the small variant of the button.
  static const _smallMaximumSize = Size(double.infinity, 40);

  /// The minimum size of the small variant of the button.
  static const _smallMinimumSize = Size(90, 40);

  /// The maximum size of the button.
  static const _defaultMaximumSize = Size(double.infinity, 56);

  /// The minimum size of the button.
  static const _defaultMinimumSize = Size(double.infinity, 56);

  /// The padding of the the button.
  static const _defaultPadding = EdgeInsets.symmetric(vertical: AppSpacing.lg);

  /// [VoidCallback] called when button is pressed.
  /// Button is disabled when null.
  final VoidCallback? onPressed;

  /// A background color of the button.
  ///
  /// Defaults to [Colors.white].
  final Color _buttonColor;

  /// A disabled background color of the button.
  ///
  /// Defaults to [AppColors.disabledButton].
  final Color? _disabledButtonColor;

  /// Color of the text, icons etc.
  ///
  /// Defaults to [AppColors.black].
  final Color _foregroundColor;

  /// Color of the disabled text, icons etc.
  ///
  /// Defaults to [AppColors.disabledForeground].
  final Color _disabledForegroundColor;

  /// A border of the button.
  final BorderSide? _borderSide;

  /// Elevation of the button.
  final double _elevation;

  /// Elevation of the button.
  final double _borderRadius;

  /// [TextStyle] of the button text.
  ///
  /// Defaults to [TextTheme.labelLarge].
  final TextStyle? _textStyle;

  /// The maximum size of the button.
  ///
  /// Defaults to [_defaultMaximumSize].
  final Size _maximumSize;

  /// The minimum size of the button.
  ///
  /// Defaults to [_defaultMinimumSize].
  final Size _minimumSize;

  /// The padding of the button.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets _padding;

  /// [Widget] displayed on the button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textStyle = _textStyle ??
        Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: AppColors.white);

    final elevatedButton = ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(_maximumSize),
        padding: MaterialStateProperty.all(_padding),
        minimumSize: MaterialStateProperty.all(_minimumSize),
        textStyle: MaterialStateProperty.all(textStyle),
        backgroundColor: onPressed == null
            ? MaterialStateProperty.all(_disabledButtonColor)
            : MaterialStateProperty.all(_buttonColor),
        elevation: MaterialStateProperty.all(_elevation),
        foregroundColor: onPressed == null
            ? MaterialStateProperty.all(_disabledForegroundColor)
            : MaterialStateProperty.all(_foregroundColor),
        side: MaterialStateProperty.all(_borderSide),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      ),
      child: child,
    );
    return elevatedButton;
  }
}

///For navigating to the previous page
class ArrowBackButton extends StatelessWidget {
  ///
  const ArrowBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
      ],
    );
  }
}
