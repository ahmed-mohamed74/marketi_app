import 'package:hive/hive.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';

class OrderLocalService {
  final Box<OrderModel> _orderBox = Hive.box<OrderModel>('orders_box');

  Future<void> saveOrder(OrderModel order) async {
    await _orderBox.put(order.id, order);
  }

  List<OrderModel> getAllOrders() {
    return _orderBox.values.toList();
  }

  Future<void> deleteOrder(String orderId) async {
    await _orderBox.delete(orderId);
  }
}