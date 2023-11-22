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
    bool? isLoadingShimmer,
    double borderRadius = 10,
    super.key,
  })  : _buttonColor = buttonColor ?? Colors.white,
        _disabledButtonColor = disabledButtonColor ?? AppColors.disabledButton,
        _borderSide = borderSide,
        _borderRadius = borderRadius,
        _isLoadingShimmer = isLoadingShimmer ?? false,
        _foregroundColor = foregroundColor ?? AppColors.black,
        _disabledForegroundColor =
            disabledForegroundColor ?? AppColors.disabledForeground,
        _elevation = elevation ?? 0,
        _textStyle = textStyle,
        _maximumSize = maximumSize ?? _defaultMaximumSize,
        _minimumSize = minimumSize ?? _defaultMinimumSize,
        _padding = padding ?? _defaultPadding;

  /// Filled black button.
  const AppButton.black({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.black,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled blue dress button.
  const AppButton.blueDress({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.blueDress,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled crystal blue button.
  const AppButton.crystalBlue({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.crystalBlue,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled red wine button.
  const AppButton.redWine({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.redWine,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled secondary button.
  const AppButton.secondary({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    Color? disabledButtonColor,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.secondary,
          child: child,
          foregroundColor: AppColors.white,
          disabledButtonColor: disabledButtonColor ?? AppColors.disabledSurface,
          elevation: elevation,
          textStyle: textStyle,
          padding: _smallPadding,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
        );

  /// Filled dark aqua button.
  const AppButton.darkAqua({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.darkAqua,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Outlined white button.
  const AppButton.outlinedWhite({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          buttonColor: AppColors.white,
          borderSide: const BorderSide(
            color: AppColors.pastelGrey,
          ),
          elevation: elevation,
          foregroundColor: AppColors.lightBlack,
          textStyle: textStyle,
        );

  /// Outlined transparent dark aqua button.
  const AppButton.outlinedTransparentDarkAqua({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          buttonColor: AppColors.transparent,
          borderSide: const BorderSide(
            color: AppColors.paleSky,
          ),
          elevation: elevation,
          foregroundColor: AppColors.darkAqua,
          textStyle: textStyle,
        );

  /// Outlined transparent white button.
  const AppButton.outlinedTransparentWhite({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          buttonColor: AppColors.transparent,
          borderSide: const BorderSide(
            color: AppColors.white,
          ),
          elevation: elevation,
          foregroundColor: AppColors.white,
          textStyle: textStyle,
        );

  /// Outlined transparent green button.
  const AppButton.outlinedTransparentGreen({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          buttonColor: AppColors.transparent,
          borderSide: const BorderSide(color: AppColors.green, width: 3),
          elevation: elevation,
          foregroundColor: AppColors.white,
          textStyle: textStyle,
        );

  /// filled dark blue button
  const AppButton.primary({
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
          buttonColor: AppColors.enabledButtonBackgroundColor,
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

  /// Filled transparent dark aqua button.
  const AppButton.transparentDarkAqua({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          buttonColor: AppColors.transparent,
          elevation: elevation,
          foregroundColor: AppColors.darkAqua,
          textStyle: textStyle,
        );

  /// Filled transparent white button.
  const AppButton.transparentWhite({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          disabledButtonColor: AppColors.transparent,
          buttonColor: AppColors.transparent,
          elevation: elevation,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white,
          textStyle: textStyle,
        );

  /// Filled transparent white button.
  const AppButton.transparentWithBlueBorder({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          disabledButtonColor: AppColors.transparent,
          buttonColor: AppColors.transparent,
          elevation: elevation,
          borderSide: const BorderSide(color: AppColors.skyBlue),
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white,
          textStyle: textStyle,
          padding: _smallPadding,
        );

  /// Filled transparent white button.
  const AppButton.transparentWithBlueBorderSmall({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          disabledButtonColor: AppColors.transparent,
          buttonColor: AppColors.transparent,
          elevation: elevation,
          borderSide: const BorderSide(color: AppColors.darkAqua),
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white,
          textStyle: textStyle,
          padding: const EdgeInsets.only(top: 2),
        );

  /// Filled small red wine blue button.
  const AppButton.smallRedWine({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.redWine,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  /// Filled small transparent button.
  const AppButton.smallDarkAqua({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.darkAqua,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  /// Filled small green button.
  const AppButton.smallGreen({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.green,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  /// Filled small green button.
  const AppButton.smallLightGreen({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: const Color.fromRGBO(246, 254, 249, 1),
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  /// Filled small transparent button.
  const AppButton.smallTransparent({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.transparent,
          child: child,
          foregroundColor: AppColors.darkAqua,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  /// Filled small transparent button.
  const AppButton.smallOutlineTransparent({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.transparent,
          child: child,
          borderSide: const BorderSide(
            color: AppColors.paleSky,
          ),
          foregroundColor: AppColors.darkAqua,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  ///
  const AppButton.smallFilledGray({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.black,
          child: child,
          borderRadius: 30,
          borderSide: BorderSide.none,
          foregroundColor: AppColors.darkAqua,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  ///
  const AppButton.smallFilledYellow({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: const Color.fromRGBO(242, 153, 74, 1),
          child: child,
          borderRadius: 30,
          borderSide: BorderSide.none,
          foregroundColor: AppColors.darkAqua,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  ///
  const AppButton.smallFilledRedWhine({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: const Color.fromRGBO(255, 248, 235, 1),
          child: child,
          borderRadius: 30,
          borderSide: BorderSide.none,
          foregroundColor: const Color.fromRGBO(255, 248, 235, 1),
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: _smallPadding,
        );

  ///
  const AppButton.smallFilledGreen({
    required Widget child,
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: const Color.fromRGBO(18, 183, 106, 1),
          child: child,
          borderRadius: 30,
          borderSide: BorderSide.none,
          foregroundColor: const Color.fromRGBO(255, 248, 235, 1),
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          minimumSize: _smallMinimumSize,
          padding: const EdgeInsets.only(left: 3, right: 3),
        );

  /// The maximum size of the small variant of the button.
  static const _smallMaximumSize = Size(double.infinity, 40);

  /// The minimum size of the small variant of the button.
  static const _smallMinimumSize = Size(0, 40);

  /// The maximum size of the button.
  static const _defaultMaximumSize = Size(double.infinity, 56);

  /// The minimum size of the button.
  static const _defaultMinimumSize = Size(double.infinity, 56);

  /// The padding of the small variant of the button.
  static const _smallPadding = EdgeInsets.symmetric(horizontal: AppSpacing.md);

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

  /// To enable a loading shimmer of the button.
  final bool _isLoadingShimmer;

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
