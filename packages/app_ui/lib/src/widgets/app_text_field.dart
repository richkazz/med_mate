import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template app_text_field}
/// A text field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
/// {@endtemplate}
class AppTextField extends StatelessWidget {
  /// {@macro app_text_field}
  const AppTextField({
    super.key,
    this.initialValue,
    this.autoFillHints,
    this.controller,
    this.inputFormatters,
    this.autocorrect = true,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.borderRadiusCircularSize = 0,
    this.obscureText = false,
  });

  /// A value to initialize the field to.
  final String? initialValue;

  /// List of auto fill hints.
  final Iterable<String>? autoFillHints;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional input validation.
  final String? Function(String?)? validator;

  /// Whether to enable obscureText.
  /// Defaults to false.
  final bool obscureText;

  /// Whether to enable autocorrect.
  /// Defaults to true.
  final bool autocorrect;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool readOnly;

  /// The BorderRadius.circular(0) number.
  /// Defaults to 0.
  final double borderRadiusCircularSize;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text] if maxLines is one and
  /// [TextInputType.multiline] otherwise.
  final TextInputType? keyboardType;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.colorScheme.brightness == Brightness.light;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: TextFormField(
            key: key,
            initialValue: initialValue,
            controller: controller,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            autocorrect: autocorrect,
            readOnly: readOnly,
            autofillHints: autoFillHints,
            validator: validator,
            cursorColor: AppColors.darkAqua,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isLightMode ? null : AppColors.black,
                ),
            onFieldSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefix,
              suffixIcon: suffix,
              fillColor: AppColors.textFieldFillColor,
              filled: true,
              error: errorText == null
                  ? null
                  : Text(
                      errorText!,
                      softWrap: true,
                      style:
                          const TextStyle(color: AppColors.red, fontSize: 13),
                    ),
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 32,
                height: 32,
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 48,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusCircularSize),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusCircularSize),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusCircularSize),
                borderSide:
                    const BorderSide(color: Color.fromRGBO(212, 225, 255, 1)),
              ),
            ),
            onChanged: onChanged,
            onTap: onTap,
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }
}

class _PasswordEyeChange extends StatelessWidget {
  const _PasswordEyeChange({
    required this.onTap,
    required this.isPasswordVisible,
  });
  final VoidCallback onTap;
  final bool isPasswordVisible;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        isPasswordVisible
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
      ),
    );
  }
}

/// {@template app_text_field}
/// A text field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
/// {@endtemplate}
class AppTextFieldOutlined extends StatefulWidget {
  /// {@macro app_text_field}
  const AppTextFieldOutlined({
    super.key,
    this.initialValue,
    this.autoFillHints,
    this.controller,
    this.inputFormatters,
    this.autocorrect = true,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.borderRadiusCircularSize = 0,
    this.obscureText = false,
    this.focusNode,
    this.labelText,
  });

  /// A value to initialize the field to.
  final String? initialValue;

  /// List of auto fill hints.
  final Iterable<String>? autoFillHints;

  /// A value to initialize the field to.
  final FocusNode? focusNode;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional input validation.
  final String? Function(String?)? validator;

  /// Whether to enable obscureText.
  /// Defaults to false.
  final bool obscureText;

  /// Whether to enable autocorrect.
  /// Defaults to true.
  final bool autocorrect;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool readOnly;

  /// The BorderRadius.circular(0) number.
  /// Defaults to 0.
  final double borderRadiusCircularSize;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that suggests what sort of input the field accepts.
  final String? labelText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text] if maxLines is one and
  /// [TextInputType.multiline] otherwise.
  final TextInputType? keyboardType;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  @override
  State<AppTextFieldOutlined> createState() => _AppTextFieldOutlinedState();
}

class _AppTextFieldOutlinedState extends State<AppTextFieldOutlined> {
  late bool isPasswordVisible;
  @override
  void initState() {
    isPasswordVisible = widget.obscureText;

    super.initState();
  }

  void onPasswordVisibilityChange() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.colorScheme.brightness == Brightness.light;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: TextFormField(
            key: widget.key,
            focusNode: widget.focusNode,
            initialValue: widget.initialValue,
            controller: widget.controller,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            autocorrect: widget.autocorrect,
            readOnly: widget.readOnly,
            autofillHints: widget.autoFillHints,
            validator: widget.validator,
            cursorColor: AppColors.darkAqua,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            onFieldSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              hintText: widget.hintText,
              labelText: widget.labelText,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: !isLightMode
                      ? const Color.fromRGBO(252, 252, 253, 1)
                      : AppColors.fieldBorderColor,
                  fontSize: 13),
              error: widget.errorText == null
                  ? null
                  : Text(
                      widget.errorText!,
                      softWrap: true,
                      style:
                          const TextStyle(color: AppColors.red, fontSize: 13),
                    ),
              prefixIcon: widget.prefix,
              suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                  ? _PasswordEyeChange(
                      isPasswordVisible: isPasswordVisible,
                      onTap: onPasswordVisibilityChange,
                    )
                  : widget.suffix,
              errorMaxLines: 7,
              filled: true,
              fillColor: isLightMode
                  ? const Color.fromRGBO(252, 252, 253, 1)
                  : theme.colorScheme.background,
              labelStyle: ContentTextStyle.bodyText1,
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 32,
                height: 32,
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 48,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.background,
                  style: BorderStyle.none,
                ),
                borderRadius:
                    BorderRadius.circular(widget.borderRadiusCircularSize),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.blue,
                ),
                borderRadius:
                    BorderRadius.circular(widget.borderRadiusCircularSize),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromRGBO(208, 213, 221, 1),
                ),
                borderRadius:
                    BorderRadius.circular(widget.borderRadiusCircularSize),
              ),
            ),
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            obscureText: isPasswordVisible,
          ),
        ),
      ],
    );
  }
}

/// {@template app_text_field}
/// A text field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
/// {@endtemplate}
class AppOTPTextFieldOutlined extends StatelessWidget {
  /// {@macro app_text_field}
  const AppOTPTextFieldOutlined({
    required this.focusNode,
    super.key,
    this.initialValue,
    this.autoFillHints,
    this.controller,
    this.autocorrect = true,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.borderRadiusCircularSize = 0,
    this.obscureText = false,
  });

  /// A value to initialize the field to.
  final String? initialValue;

  /// A value to initialize the field to.
  final FocusNode focusNode;

  /// List of auto fill hints.
  final Iterable<String>? autoFillHints;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// Optional input validation.
  final String? Function(String?)? validator;

  /// Whether to enable obscureText.
  /// Defaults to false.
  final bool obscureText;

  /// Whether to enable autocorrect.
  /// Defaults to true.
  final bool autocorrect;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool readOnly;

  /// The BorderRadius.circular(0) number.
  /// Defaults to 0.
  final double borderRadiusCircularSize;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text] if maxLines is one and
  /// [TextInputType.multiline] otherwise.
  final TextInputType? keyboardType;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.colorScheme.brightness == Brightness.light;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80, maxWidth: 40),
          child: TextFormField(
            key: key,
            initialValue: initialValue,
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: keyboardType,
            autocorrect: autocorrect,
            readOnly: readOnly,
            autofillHints: autoFillHints,
            validator: validator,
            cursorColor: AppColors.darkAqua,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isLightMode ? null : AppColors.black,
                ),
            onFieldSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              errorText: errorText,
              prefixIcon: prefix,
              suffixIcon: suffix,
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 32,
                height: 32,
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 48,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusCircularSize),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(borderRadiusCircularSize),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(borderRadiusCircularSize),
              ),
            ),
            focusNode: focusNode,
            onChanged: onChanged,
            onTap: onTap,
            obscureText: obscureText,
          ),
        ),
      ],
    );
  }
}
