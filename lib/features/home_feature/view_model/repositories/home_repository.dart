import 'package:dartz/dartz.dart';
import 'package:marketi_app/core/dummy_data.dart';
import 'package:marketi_app/features/home_feature/view_model/models/category_model.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';

class HomeRepository {
  Future<Either<String, List<ProductModel>>> getPopularProducts() async {
    try {
      final response = DummyData.products;
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
  Future<Either<String, List<ProductModel>>> getBestProducts()async {
    try {
      final response = DummyData.bestproducts;
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
  /////
   Future<Either<String, List<ProductModel>>> getBuyAgainProducts()async {
    try {
      final response = DummyData.buyAgainProducts;
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
   Future<Either<String, List<CategoryBrandModel>>> getCategories()async {
    try {
      final response = DummyData.categories;
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
   Future<Either<String, List<CategoryBrandModel>>> getBrands()async {
    try {
      final response = DummyData.brands;
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
