import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:marketi_app/core/services/api/api_consumer.dart';
import 'package:marketi_app/core/services/api/end_points.dart';
import 'package:marketi_app/features/home_feature/view_model/models/brand_model.dart';
import 'package:marketi_app/features/home_feature/view_model/models/category_model.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';

class HomeRepository {
  final ApiConsumer api;

  HomeRepository({required this.api});Future<Either<String, List<ProductModel>>> getAllProducts({
  required int skip,
  required int limit,
}) async {
  try {
    final response = await api.get(
      EndPoints.getAllProductsData,
      queryParameters: {'skip': skip, 'limit': limit},
    );

    // decode response if it's a JSON string
    final data = response is String ? jsonDecode(response) : response;

    final products = (data['list'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();

    return Right(products);
  } catch (e) {
    return Left(e.toString());
  }
}
  Future<Either<String, List<ProductModel>>> getPopularProducts() async {
    try {
      final response = await api.post(
        EndPoints.getPopularProductsData,
        data: {
          "skip": 0,
          "search": "",
          "brand": "",
          "category": "",
          "rating": "",
          "price": "",
          "discount": "",
          "popular": true,
          "limit": 10,
        },
      );
      final products = (response['list'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<ProductModel>>> getBestProducts() async {
    try {
      final response = await api.post(
        EndPoints.getPopularProductsData,
        data: {
          "skip": 0,
          "search": "",
          "brand": "",
          "category": "",
          "rating": "5",
          "price": "",
          "discount": "",
          "popular": true,
          "limit": 10,
        },
      );
      final products = (response['list'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<ProductModel>>> getBuyAgainProducts() async {
    try {
      final response = await api.post(
        EndPoints.getPopularProductsData,
        data: {
          "skip": 0,
          "search": "",
          "brand": "",
          "category": "",
          "rating": "",
          "price": "",
          "discount": "",
          "popular": false,
          "limit": 10,
        },
      );
      final products = (response['list'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      final response = await api.get(EndPoints.getCategoriesData);
      final categories = (response['list'] as List)
          .map((e) => CategoryModel.fromMap(e))
          .toList();
      return Right(categories);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<BrandModel>>> getBrands() async {
    try {
      final response = await api.get(EndPoints.getBrandsData);
      final brands = (response['list'] as List? ?? [])
          .map((e) => BrandModel.fromMap(e))
          .toList();
      return Right(brands);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
