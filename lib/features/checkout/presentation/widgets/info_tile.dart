import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? trailingText;
  final VoidCallback? onTrailingPressed;

  const InfoTile({
    required this.icon,
    required this.text,
    this.trailingText,
    this.onTrailingPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlueColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.darkBlueColor),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.titleSmall),
          const Spacer(),
          if (trailingText != null)
            TextButton(
              onPressed: onTrailingPressed, // Use the callback here
              child: Text(
                trailingText!,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: AppColors.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
