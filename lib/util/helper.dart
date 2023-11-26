import 'package:domain/domain.dart';

RegExp passwordRegex = RegExp(
  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$',
);

RegExp nameRegex = RegExp(r'^[a-zA-Z]+(?: +[a-zA-Z]+)*$');
RegExp emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  caseSensitive: false,
);
String? validateEmail(String? val, String name) {
  if (val.isNullOrWhiteSpace || !emailRegex.hasMatch(val!)) {
    return '$name not valid';
  }
  return null;
}

String? validateName(String? val, String name) {
  if (val.isNullOrWhiteSpace || !nameRegex.hasMatch(val!)) {
    return '$name not valid';
  }
  return null;
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (password.isNullOrWhiteSpace ||
      confirmPassword.isNullOrWhiteSpace ||
      password != confirmPassword) {
    return 'Confirm password must match the password';
  }
  return null;
}

String? validatePassword(String? val, String errorText) {
  if (val.isNullOrWhiteSpace || !passwordRegex.hasMatch(val!)) {
    return 'Password must:\n- Be at least 8 characters long\n- Contain at'
        ' least one uppercase letter\n- Contain at least one '
        'lowercase letter\n-'
        ' Contain at least one digit\n- Contain at least one'
        ' special character'
        r' (!@#$%^&*(),.?":{}|<>)';
  }
  return null;
}
