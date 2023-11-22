import 'package:flutter/material.dart';

/// A custom checkbox widget that allows the user to toggle the state of the checkbox.
class AppCheckbox extends StatefulWidget {
  /// Creates a new [AppCheckbox] instance.
  const AppCheckbox({
    required this.onChanged,
    required this.value,
    super.key,
    this.checkColor,
  });

  /// The callback function that will be called when the value of the checkbox changes.
  final ValueChanged<bool>? onChanged;

  /// The current value of the checkbox.
  final bool value;

  /// The current value of the checkbox.
  final Color? checkColor;

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: widget.checkColor,
      value: _value,
      onChanged: widget.onChanged != null
          ? (bool? value) {
              setState(() {
                _value = value ?? false;
              });
              widget.onChanged!(value ?? false);
            }
          : null,
    );
  }
}
