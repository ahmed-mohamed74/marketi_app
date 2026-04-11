import 'package:dartz/dartz.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';

class FavouriteRepository {
  final ApiConsumer api;

  FavouriteRepository({required this.api});
  Future<Either<String, List<ProductModel>>> getFavouriteProducts() async {
    try {
      final response = await api.get(EndPoints.getFavouriteProducts);
      final products = (response['list'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> addFavouriteProduct({required String id}) async {
    try {
      final response = await api.post(
        EndPoints.addFavouriteProduct,
        data: {"productId": id},
      );
      final successMessage = response['message'] as String;

      return Right(successMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deleteFavouriteProduct({required String id}) async {
    try {
      final response = await api.delete(
        EndPoints.deleteFavouriteProduct,
        data: {"productId": id},
      );
      final successMessage = response['message'] as String;

      return Right(successMessage);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
