import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? const CircularProgressIndicator() : Text(text),
    );
  }
}
