import 'package:flutter/services.dart';

class CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');


    if (newText.length > 5) {
      newText = newText.substring(0, 5) + '-' + newText.substring(5);
    }
    if (newText.length > 13) {
      newText = newText.substring(0, 13) + '-' + newText.substring(13);
    }

    // Limit the length to 15 characters (e.g., 5 digits + 1 dash + 7 digits + 1 dash + 1 digit)
    newText = newText.substring(0, newText.length > 15 ? 15 : newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
