import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const SectionHeaderWidget({
    super.key, required this.title, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading1),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'View all',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
