import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_sizes.dart';
import 'package:marketi_app/core/services/payment/stripe_payment/payment_manager.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';

class CheckoutPage extends StatelessWidget {
  final double? amount;
  final int? suptotalItems;
  const CheckoutPage({
    super.key,
    required this.amount,
    required this.suptotalItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text('Checkout', style: AppTextStyles.appBarTitle1),
        actions: const [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              backgroundColor: AppColors.lightBlueColor,
              foregroundColor: AppColors.navyColor,
              child: Icon(Icons.person_2_outlined, size: 30),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Address'),
            const SizedBox(height: 10),
            const AddressCard(),
            const SizedBox(height: 14),
            const SectionTitle(title: 'Delivery time'),
            const SizedBox(height: 10),
            const InfoTile(
              icon: Icons.local_shipping_outlined,
              text: 'Within 2 days',
            ),
            const SizedBox(height: 14),
            const SectionTitle(title: 'Payment'),
            const SizedBox(height: 10),
            const InfoTile(
              icon: Icons.payments_outlined,
              text: 'Cash on delivery',
              trailingText: 'Change',
            ),
            const SizedBox(height: 10),
            const VoucherSection(),
            const SizedBox(height: 14),
            const SectionTitle(title: 'Payment'),
            const SizedBox(height: 10),
            OrderSummaryCard(
              suptotalItems: suptotalItems ?? 0,
              amount: amount ?? 0,
            ),
            const SizedBox(height: 14),
            PrimaryButtonWidget(
              text: 'Place Order',
              onPressed: () =>
                  PaymentManager.makePayment(amount!.toInt(), "EGP"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlueColor),
      ),
      child: Column(
        children: [
          Container(
            height: AppSizes(context: context).screenHeight * 0.09,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(
                  'https://placeholder.com/map_image',
                ), // Replace with actual map static image
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.darkBlueColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Home', style: AppTextStyles.heading2),
                      Text(
                        'Anshas, Al-sharqia, Egypt.',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.navyColor,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Mobile: +20 101 840 3043',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.navyColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Change',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
            value: 'EGP $amount.00',
          ),
          const SizedBox(height: 8),
          const SummaryRow(label: 'Delivery Fees', value: 'EGP 10.00'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              '- - - - - - - - - - - - - - - - - - - - - - - -',
              style: TextStyle(color: AppColors.lightBlueColor),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyles.heading3),
              Text('EGP ${amount + 10}.00', style: AppTextStyles.heading3),
            ],
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.heading2);
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? trailingText;

  const InfoTile({
    required this.icon,
    required this.text,
    this.trailingText,
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
          Text(text, style: AppTextStyles.heading3),
          const Spacer(),
          if (trailingText != null)
            TextButton(
              onPressed: () {},
              child: Text(
                trailingText!,
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

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
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
          style: AppTextStyles.heading3.copyWith(color: AppColors.navyColor),
        ),
      ],
    );
  }
}
