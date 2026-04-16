import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:marketi_app/core/common/widgets/back_button_widget.dart';
import 'package:marketi_app/core/themes/colors.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';
import 'package:marketi_app/features/order/presentation/cubit/order_cubit.dart';

class OredrHistory extends StatefulWidget {
  const OredrHistory({super.key});

  @override
  State<OredrHistory> createState() => _OredrHistoryState();
}

class _OredrHistoryState extends State<OredrHistory> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(onPressed: () => context.pop()),
        leadingWidth: 64,
        title: const Text('Orders History'),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderSuccess) {
            if (state.orders.isEmpty) return _buildEmptyState();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _buildOrderCard(order);
              },
            );
          }
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightBlueColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.receipt_long, color: AppColors.navyColor),
        ),
        title: Text(
          'Order #${order.id.substring(order.id.length - 5)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${order.products.length} Items'),
            Text(
              DateFormat('dd MMM yyyy, hh:mm a').format(order.date),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${order.totalPrice.toStringAsFixed(2)} EGP',
              style: const TextStyle(
                color: AppColors.navyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
        onTap: () => _showOrderDetails(order),
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Order Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: order.products.length,
                itemBuilder: (context, index) {
                  final product = order.products[index];
                  return ListTile(
                    leading: Image.network(
                      product.images?.first ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(product.title ?? 'No Name'),
                    subtitle: Text('${product.price} EGP'),
                    trailing: Text('x ${product.quantity}'),
                  );
                },
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '${order.totalPrice.toStringAsFixed(2)} EGP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.navyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No orders yet!',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
