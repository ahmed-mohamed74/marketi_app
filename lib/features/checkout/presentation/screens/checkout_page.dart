import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/services/payment/stripe_payment/stripe_keys.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/checkout/presentation/payment_cubit/payment_cubit.dart';
import 'package:marketi_app/features/checkout/presentation/widgets/address_card.dart';
import 'package:marketi_app/features/checkout/presentation/widgets/info_tile.dart';
import 'package:marketi_app/features/checkout/presentation/widgets/order_summery_card.dart';
import 'package:marketi_app/features/checkout/presentation/widgets/voucher_section.dart';
import 'package:marketi_app/features/home/presentation/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';
import 'package:url_launcher/url_launcher.dart';

enum PaymentMethod { cash, card }

class CheckoutPage extends StatefulWidget {
  final OrderModel? orderModel;
  const CheckoutPage({super.key, required this.orderModel});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod selectedMethod = PaymentMethod.cash;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: Text('Checkout', style: theme.textTheme.titleLarge),
        actions: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  context.read<NavigationCubit>().updateIndex(3);
                  context.push(AppRoutes.home);
                });
              },
              child: CircleAvatar(
                child: Icon(Icons.person_2_outlined, size: 30),
              ),
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
              suptotalItems: widget.orderModel?.products.length ?? 0,
              amount: widget.orderModel?.totalPrice ?? 0,
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
                if (state is PaymentSuccess) {
                  context.read<PaymentCubit>().saveOrder(widget.orderModel!);
                }
                if (state is SaveOrderSuccess) {
                  context.push(AppRoutes.orderHistoryPage);
                }
              },
              builder: (context, state) {
                if (state is PaymentLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  child: Text(
                    selectedMethod == PaymentMethod.cash
                        ? 'Confirm via WhatsApp'
                        : 'Pay Now',
                  ),
                  onPressed: () {
                    if (selectedMethod == PaymentMethod.card) {
                      context.read<PaymentCubit>().makePayment(
                        widget.orderModel!.totalPrice.round(),
                        "EGP",
                      );
                    } else {
                      _sendWhatsAppOrder();
                      context.read<PaymentCubit>().saveOrder(
                        widget.orderModel!,
                      );
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
    const String phoneNumber =
        StripeKeys.companyPhoneNumber; // Your company number
    final String message =
        "Hello Marketi! I'd like to confirm my order:\n"
        "Total Items: ${widget.orderModel?.products.length??0}\n"
        "Total Amount: EGP ${(widget.orderModel?.totalPrice??0 + 10).round()}\n"
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
              Text(
                "Select Payment Method",
                style: Theme.of(context).textTheme.titleMedium,
              ),
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

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}
