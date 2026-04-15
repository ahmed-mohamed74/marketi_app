import 'package:dartz/dartz.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/network/connection_checker.dart';
import 'package:marketi_app/core/services/cache/product_local_data_source.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';

class FavouriteRepository {
  final ApiConsumer api;
  final ProductLocalDataSource productLocalDataSource;
  final ConnectionChecker connectionChecker;

  FavouriteRepository({
    required this.api,
    required this.productLocalDataSource,
    required this.connectionChecker,
  });
  Future<Either<String, List<ProductModel>>> getFavouriteProducts() async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.get(EndPoints.getFavouriteProducts);
        final products = (response['list'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        await productLocalDataSource.cacheFavoriteProducts(products: products);
        return Right(products);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      final favProducts = productLocalDataSource.getCachedFavoriteProducts();
      return favProducts.isNotEmpty
          ? Right(favProducts)
          : const Left("No internet and no cached favorites.");
    }
  }

  Future<Either<String, String>> addFavouriteProduct({
    required String id,
  }) async {
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

  Future<Either<String, String>> deleteFavouriteProduct({
    required String id,
  }) async {
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
