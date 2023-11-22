import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum OtpTextFieldAction {
  start,
  clearTextFieldsShowError,
  clearTextFields,
  externalSunmit;
}

///For controlling [OtpTextField]
class OtpTextFieldController extends ChangeNotifier {
  OtpTextFieldAction _action = OtpTextFieldAction.start;

  ///Get the current action been performed
  OtpTextFieldAction get getAction => _action;

  ///
  void clearTextFieldsShowError() {
    _action = OtpTextFieldAction.clearTextFieldsShowError;
    notifyListeners();
  }

  ///
  void clearTextFields() {
    _action = OtpTextFieldAction.clearTextFields;
    notifyListeners();
  }

  ///
  void externalSunmit() {
    _action = OtpTextFieldAction.externalSunmit;
    notifyListeners();
  }
}

///A number of text fields for inputing otp
class OtpTextField extends StatefulWidget {
  ///The constant con
  const OtpTextField({
    super.key,
    this.submit,
    this.borderRadiusCircularSize = 0,
    this.otpTextFieldController,
  });

  ///To set the border radius of the text fields
  final double borderRadiusCircularSize;

  ///for controlling the [OtpTextField]
  final OtpTextFieldController? otpTextFieldController;

  /// A call back for when the user has inputed all the fields
  final ValueChanged<String>? submit;
  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField>
    with TickerProviderStateMixin {
  final _token1Controller = TextEditingController();
  final _token2Controller = TextEditingController();
  final _token3Controller = TextEditingController();
  final _token4Controller = TextEditingController();
  final _token5Controller = TextEditingController();

  int _currentFocusedField = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode myFocusNode1;
  late FocusNode myFocusNode2;
  late FocusNode myFocusNode3;
  late FocusNode myFocusNode4;
  late FocusNode myFocusNode5;
  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late AnimationController _animationController3;
  late AnimationController _animationController4;
  late AnimationController _animationController5;
  final animationDuration = const Duration(milliseconds: 1000);
  bool reValidate = false;
  @override
  void initState() {
    super.initState();
    _token1Controller.addListener(() {
      _currentFocusedField = 1;
    });
    _token2Controller.addListener(() {
      _currentFocusedField = 2;
    });
    _token3Controller.addListener(() {
      _currentFocusedField = 3;
    });
    _token4Controller.addListener(() {
      _currentFocusedField = 4;
    });

    _token5Controller.addListener(() {
      _currentFocusedField = 5;
    });

    myFocusNode1 = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
    myFocusNode4 = FocusNode();
    myFocusNode5 = FocusNode();

    _animationController1 =
        AnimationController(vsync: this, duration: animationDuration);

    _animationController2 =
        AnimationController(vsync: this, duration: animationDuration);

    _animationController3 =
        AnimationController(vsync: this, duration: animationDuration);

    _animationController4 =
        AnimationController(vsync: this, duration: animationDuration);

    _animationController5 =
        AnimationController(vsync: this, duration: animationDuration);

    _animationController1.addListener(_animationListener);
    _animationController2.addListener(_animationListener);
    _animationController3.addListener(_animationListener);
    _animationController4.addListener(_animationListener);
    _animationController5.addListener(_animationListener);
    if (widget.otpTextFieldController != null) {
      widget.otpTextFieldController!.addListener(() {
        switch (widget.otpTextFieldController!.getAction) {
          case OtpTextFieldAction.clearTextFields:
            clearTextFields();
            break;
          case OtpTextFieldAction.start:
            break;
          case OtpTextFieldAction.clearTextFieldsShowError:
            clearTextFieldsShowError();
            break;
          case OtpTextFieldAction.externalSunmit:
            externalSunmit();
            break;
        }
      });
    }
  }

  void _animationListener() {
    if (_animationController1.isCompleted) {
      _animationController1.reset();
    }
    if (_animationController2.isCompleted) {
      _animationController2.reset();
    }
    if (_animationController3.isCompleted) {
      _animationController3.reset();
    }
    if (_animationController4.isCompleted) {
      _animationController4.reset();
    }
    if (_animationController5.isCompleted) {
      _animationController5.reset();
    }
  }

//.animate().shake(hz: 3, offset: const Offset(10, 0))
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppOTPTextFieldOutlined(
            borderRadiusCircularSize: widget.borderRadiusCircularSize,
            focusNode: myFocusNode1,
            validator: tokenValidator,
            onChanged: _onNumberEntered,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            controller: _token1Controller,
          )
              .animate(controller: _animationController1, autoPlay: false)
              .shake(hz: 7, offset: const Offset(10, 0)),
          const SizedBox(width: AppSpacing.md),
          AppOTPTextFieldOutlined(
            borderRadiusCircularSize: widget.borderRadiusCircularSize,
            focusNode: myFocusNode2,
            validator: tokenValidator,
            onChanged: _onNumberEntered,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            controller: _token2Controller,
          )
              .animate(controller: _animationController2, autoPlay: false)
              .shake(hz: 7, offset: const Offset(10, 0)),
          const SizedBox(width: AppSpacing.md),
          AppOTPTextFieldOutlined(
            borderRadiusCircularSize: widget.borderRadiusCircularSize,
            focusNode: myFocusNode3,
            validator: tokenValidator,
            onChanged: _onNumberEntered,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            controller: _token3Controller,
          )
              .animate(controller: _animationController3, autoPlay: false)
              .shake(hz: 7, offset: const Offset(10, 0)),
          const SizedBox(width: AppSpacing.md),
          AppOTPTextFieldOutlined(
            borderRadiusCircularSize: widget.borderRadiusCircularSize,
            focusNode: myFocusNode4,
            validator: tokenValidator,
            onChanged: _onNumberEntered,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            controller: _token4Controller,
          )
              .animate(controller: _animationController4, autoPlay: false)
              .shake(hz: 7, offset: const Offset(10, 0)),
          const SizedBox(width: AppSpacing.md),
          AppOTPTextFieldOutlined(
            borderRadiusCircularSize: widget.borderRadiusCircularSize,
            focusNode: myFocusNode5,
            validator: tokenValidator,
            onChanged: _onNumberEntered,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            controller: _token5Controller,
          )
              .animate(controller: _animationController5, autoPlay: false)
              .shake(hz: 7, offset: const Offset(10, 0)),
        ],
      ),
    );
  }

  String? tokenValidator(String? str) {
    if (str!.toLowerCase().trim().isEmpty) {
      return '';
    } else {
      return null;
    }
  }

  void _onNumberEntered(String val) {
    if (reValidate) {
      _formKey.currentState!.validate();
    }
    final curr = _currentFocusedField + 1;
    if (curr == 2 && _token1Controller.text.isNotEmpty) {
      myFocusNode2.requestFocus();
      _currentFocusedField++;
      _animationController2.forward();
    } else if (curr == 3 && _token2Controller.text.isNotEmpty) {
      myFocusNode3.requestFocus();
      _currentFocusedField++;
      _animationController3.forward();
    } else if (curr == 4 && _token3Controller.text.isNotEmpty) {
      myFocusNode4.requestFocus();
      _currentFocusedField++;
      _animationController4.forward();
    } else if (curr == 5 && _token4Controller.text.isNotEmpty) {
      myFocusNode5.requestFocus();
      _currentFocusedField++;
      _animationController5.forward();
    } else if (curr == 6 &&
        _token5Controller.text.isNotEmpty &&
        _formKey.currentState!.validate()) {
      widget.submit!(_getTokenFromTextController());
      myFocusNode5.unfocus();
    } else {
      _animationController1.forward();
      _animationController2.forward();
      _animationController3.forward();
      _animationController4.forward();
      _animationController5.forward();
      reValidate = true;
    }
  }

  String _getTokenFromTextController() {
    return _token1Controller.text +
        _token2Controller.text +
        _token3Controller.text +
        _token4Controller.text +
        _token5Controller.text;
  }

  ///External submit
  void externalSunmit() => isFormValid()
      ? widget.submit!(_getTokenFromTextController())
      : () {
          reValidate = true;
        };

  ///Clear the texfromfield and show error
  void clearTextFieldsShowError() {
    _token1Controller.text = '';
    _token2Controller.text = '';
    _token3Controller.text = '';
    _token4Controller.text = '';
    _token5Controller.text = '';
    _formKey.currentState!.validate();
    _animationController1.forward();
    _animationController2.forward();
    _animationController3.forward();
    _animationController4.forward();
    _animationController5.forward();
  }

  ///Validate the text form fields
  bool isFormValid() => _formKey.currentState!.validate();

  ///Clear the texfromfield
  void clearTextFields() {
    _token1Controller.text = '';
    _token2Controller.text = '';
    _token3Controller.text = '';
    _token4Controller.text = '';
    _token5Controller.text = '';
    _animationController1.forward();
    _animationController2.forward();
    _animationController3.forward();
    _animationController4.forward();
    _animationController5.forward();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode1.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();
    myFocusNode4.dispose();
    _token1Controller.dispose();
    _token2Controller.dispose();
    _token3Controller.dispose();
    _token4Controller.dispose();
    _token5Controller.dispose();
    _animationController1.dispose();
    if (widget.otpTextFieldController != null) {
      widget.otpTextFieldController!.dispose();
    }

    super.dispose();
  }
}
