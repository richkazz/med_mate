import 'package:app_ui/app_ui.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_mate/add_med/cubit/add_med_cubit.dart';

class TimePickerContentPickerContent extends StatefulWidget {
  const TimePickerContentPickerContent({super.key});

  @override
  State<TimePickerContentPickerContent> createState() =>
      _TimePickerContentPickerContentState();
}

class _TimePickerContentPickerContentState
    extends State<TimePickerContentPickerContent> {
  TimeOfDay? _selectedTime;

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        context.read<AddMedicationCubit>().onDosageTimeSelected(pickedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.6, 0.6, 0.6, 0),
            child: Container(
              height: 30,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(212, 225, 255, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Amount of pill(s)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  const DosageAmountInput(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(
                Icons.access_time,
                color: AppColors.primaryColor,
              ),
              onPressed: _pickTime,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            _selectedTime.isNull ? '' : _selectedTime!.formatTime,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.xxxlg),
        ],
      ),
    );
  }
}

class DosageAmountInput extends StatefulWidget {
  const DosageAmountInput({
    super.key,
  });

  @override
  State<DosageAmountInput> createState() => _DosageAmountInputState();
}

class _DosageAmountInputState extends State<DosageAmountInput> {
  String previousValue = '1';
  late TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: previousValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 30,
      child: Center(
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          onChanged: (value) {
            if (value.isEmpty) {
              return;
            }
            if (int.tryParse(value).isNull) {
              _controller.text = previousValue;
              return;
            }

            if (int.tryParse(value)! == 0) {
              return;
            }
            previousValue = value;
            context.read<AddMedicationCubit>().onDosageAmountChange(value);
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            filled: true,
            fillColor: AppColors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
