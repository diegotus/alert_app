import 'package:alert_app/app/core/utils/formater.dart';

String? validateHaitianPhoneNumber(String? value) {
  final RegExp regex = RegExp(r'^\d{4}-\d{4}$');
  if (value == null || value.isEmpty) {
    return 'Please enter your phone number';
  } else if (!regex.hasMatch(value)) {
    return 'Phone must be in the format $value +(509) 9999-9999';
  }
  return null;
}
