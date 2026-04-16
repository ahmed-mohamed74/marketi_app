import 'package:flutter/material.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/checkout/presentation/widgets/summery_row.dart';

class OrderSummaryCard extends StatelessWidget {
  final int suptotalItems;
  final double amount;
  const OrderSummaryCard({
    super.key,
    required this.suptotalItems,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlueColor),
      ),
      child: Column(
        children: [
          SummaryRow(
            label: 'Suptotal ($suptotalItems items)',
            value: 'EGP ${amount.toStringAsFixed(2)}.00',
          ),
          const SizedBox(height: 8),
          const SummaryRow(label: 'Delivery Fees', value: 'EGP 10.00'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              '- - - - - - - - - - - - - - - - - - - - -',
              style: TextStyle(color: AppColors.lightBlueColor),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: Theme.of(context).textTheme.titleSmall),
              Text(
                'EGP ${(amount + 10).toStringAsFixed(2)}.00',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
