import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class SharedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? onVisibilityChanged;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Color fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;

  const SharedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.isPassword = false,
    this.isVisible = false,
    this.onVisibilityChanged,
    this.keyboardType,
    this.maxLength,
    this.validator,
    this.fillColor = AppColors.lightGrey,
    this.inputFormatters,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isVisible,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textDark),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textDark) : null,
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.textGrey,
                ),
                onPressed: onVisibilityChanged,
              )
            : null,
        counterStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentGreen, width: 1),
        ),
      ),
      validator:
          validator ??
          (value) => value == null || value.isEmpty ? 'Field required' : null,
    );
  }
}
