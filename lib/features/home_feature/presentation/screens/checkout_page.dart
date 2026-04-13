import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/common/widgets/loader.dart';
import 'package:marketi_app/core/common/widgets/primary_button_widget.dart';
import 'package:marketi_app/core/constants/app_sizes.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/core/themes/styles.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/payment_cubit/payment_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

enum PaymentMethod { cash, card }

class CheckoutPage extends StatefulWidget {
  final double? amount;
  final int? suptotalItems;
  const CheckoutPage({
    super.key,
    required this.amount,
    required this.suptotalItems,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod selectedMethod = PaymentMethod.cash;
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
            InfoTile(
              icon: selectedMethod == PaymentMethod.cash
                  ? Icons.payments_outlined
                  : Icons.credit_card,
              text: selectedMethod == PaymentMethod.cash
                  ? 'Cash on delivery'
                  : 'Credit / Debit Card',
              trailingText: 'Change',
              onTrailingPressed: _showPaymentPicker, // Pass the function here
            ),
            const SizedBox(height: 10),
            const VoucherSection(),
            const SizedBox(height: 14),
            const SectionTitle(title: 'Payment'),
            const SizedBox(height: 10),
            OrderSummaryCard(
              suptotalItems: widget.suptotalItems ?? 0,
              amount: widget.amount ?? 0,
            ),
            const SizedBox(height: 14),
            BlocConsumer<PaymentCubit, PaymentState>(
              listener: (context, state) {
                if (state is PaymentFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error!! Amount may be less than 50 cents.',
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is PaymentLoading) {
                  return Loader();
                }
                return PrimaryButtonWidget(
                  text: selectedMethod == PaymentMethod.cash
                      ? 'Confirm via WhatsApp'
                      : 'Pay Now',
                  onPressed: () {
                    if (selectedMethod == PaymentMethod.card) {
                      context.read<PaymentCubit>().makePayment(
                        widget.amount!.round(),
                        "EGP",
                      );
                    } else {
                      _sendWhatsAppOrder();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle WhatsApp Redirection
  void _sendWhatsAppOrder() async {
    const String phoneNumber = "+201098216811"; // Your company number
    final String message =
        "Hello Marketi! I'd like to confirm my order:\n"
        "Total Items: ${widget.suptotalItems}\n"
        "Total Amount: EGP ${(widget.amount! + 10).round()}\n"
        "Payment Method: Cash on Delivery\n"
        "Address: Anshas, Al-sharqia, Egypt.";

    final Uri url = Uri.parse(
      "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Fallback if WhatsApp is not installed
      final Uri httpsUrl = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
      );
      await launchUrl(httpsUrl, mode: LaunchMode.externalApplication);
    }
  }

  void _showPaymentPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Payment Method", style: AppTextStyles.heading2),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.payments_outlined,
                  color: AppColors.primaryColor,
                ),
                title: const Text("Cash on Delivery"),
                trailing: selectedMethod == PaymentMethod.cash
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryColor,
                      )
                    : null,
                onTap: () {
                  setState(() => selectedMethod = PaymentMethod.cash);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.credit_card,
                  color: AppColors.primaryColor,
                ),
                title: const Text("Pay with Card (Stripe)"),
                trailing: selectedMethod == PaymentMethod.card
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryColor,
                      )
                    : null,
                onTap: () {
                  setState(() => selectedMethod = PaymentMethod.card);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
            value: 'EGP ${amount.toStringAsFixed(2)}.00',
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
              Text(
                'EGP ${(amount + 10).toStringAsFixed(2)}.00',
                style: AppTextStyles.heading3,
              ),
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
          Text(text, style: AppTextStyles.heading3),
          const Spacer(),
          if (trailingText != null)
            TextButton(
              onPressed: onTrailingPressed, // Use the callback here
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
