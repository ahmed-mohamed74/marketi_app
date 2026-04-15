import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';

class VoucherSection extends StatelessWidget {
  const VoucherSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Voucher code',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightBlueColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightBlueColor),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.lightBlueColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: Text(
              'Apply',
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
