import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

var phoneFormatter = MaskTextInputFormatter(
  mask: '####-####',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

MaskTextInputFormatter getPhoneFormatter(String? initialText) =>
    MaskTextInputFormatter(
      mask: '####-####',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: initialText,
      type: MaskAutoCompletionType.lazy,
    );
