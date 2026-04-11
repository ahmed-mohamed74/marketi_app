import 'package:dartz/dartz.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';

class CartRepository {
  final ApiConsumer api;

  CartRepository({required this.api});
  Future<Either<String, List<ProductModel>>> getCartProducts() async {
    try {
      final response = await api.get(EndPoints.getCartProducts);
      final products = (response['list'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> addCartProduct({required String id}) async {
    try {
      final response = await api.post(
        EndPoints.addCartProduct,
        data: {"productId": id},
      );
      final successMessage = response['message'] as String;

      return Right(successMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deleteCartProduct({required String id}) async {
    try {
      final response = await api.delete(
        EndPoints.deleteCartProduct,
        data: {"productId": id},
      );
      final successMessage = response['message'] as String;

      return Right(successMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
