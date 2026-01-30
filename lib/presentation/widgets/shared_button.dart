import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class SharedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final IconData? icon;
  final IconAlignment? iconAlignment;

  const SharedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.backgroundColor = AppColors.accentGreen,
    this.textColor = AppColors.white,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = 12,
    this.icon,
    this.iconAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white, // simplified
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      icon,
                      color: textColor,
                      size: 18,
                    ), // size 18 matches dashboard
              label: isLoading
                  ? const SizedBox()
                  : Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              iconAlignment: iconAlignment,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 0,
              ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: textColor,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
    );
  }
}
