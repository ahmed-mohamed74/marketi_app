import 'package:hive/hive.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
part 'order_model.g.dart';

@HiveType(typeId: 7)
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<ProductModel> products;

  @HiveField(2)
  final double totalPrice;

  @HiveField(3)
  final DateTime date;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.date,
  });
}