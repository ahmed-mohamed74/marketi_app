
import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const SummaryRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: AppColors.navyColor),
        ),
      ],
    );
  }
}
