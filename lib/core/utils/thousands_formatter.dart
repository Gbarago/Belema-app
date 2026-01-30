import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  final bool allowFraction;
  final int decimalPlaces;

  ThousandsFormatter({this.allowFraction = true, this.decimalPlaces = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText = newValue.text;

    // Handle initial dot
    if (newText == '.') {
      return const TextEditingValue(
        text: '00.',
        selection: TextSelection.collapsed(offset: 2),
      );
    }

    // Only allow digits and one dot
    newText = newText.replaceAll(RegExp(r'[^\d.]'), '');
    if (newText.contains('.')) {
      if (newText.indexOf('.') != newText.lastIndexOf('.')) {
        // More than one dot, revert
        return oldValue;
      }
    }

    // Split integer and fraction
    List<String> parts = newText.split('.');
    String integerPart = parts[0];
    String? fractionPart = parts.length > 1 ? parts[1] : null;

    // Limit decimal places
    if (fractionPart != null && fractionPart.length > decimalPlaces) {
      fractionPart = fractionPart.substring(0, decimalPlaces);
    }

    // Format integer part with commas
    if (integerPart.isNotEmpty) {
      final formatter = NumberFormat("#,###");
      try {
        // Remove existing commas to reformat
        integerPart = formatter.format(
          int.parse(integerPart.replaceAll(',', '')),
        );
      } catch (e) {
        // If parsing fails (e.g. too large), just keep as is or revert
      }
    }

    String formattedText = integerPart;
    if (parts.length > 1 || newValue.text.endsWith('.')) {
      formattedText += '.';
      if (fractionPart != null) {
        formattedText += fractionPart;
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
