import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/network/connection_checker.dart';
import 'package:marketi_app/core/services/cache/product_local_data_source.dart';
import 'package:marketi_app/features/home/data/models/brand_model.dart';
import 'package:marketi_app/features/home/data/models/category_model.dart';
import 'package:marketi_app/features/home/data/models/category_name_model.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';

class HomeRepository {
  final ApiConsumer api;
  final ProductLocalDataSource productLocalDataSource;
  final ConnectionChecker connectionChecker;
  HomeRepository({
    required this.api,
    required this.productLocalDataSource,
    required this.connectionChecker,
  });
  Future<Either<String, List<ProductModel>>> getAllProducts({
    required int skip,
    required int limit,
  }) async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.get(
          EndPoints.getAllProductsData,
          queryParameters: {'skip': skip, 'limit': limit},
        );
        final data = response is String ? jsonDecode(response) : response;
        final products = (data['list'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        productLocalDataSource.cacheProducts(products: products);
        return Right(products);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      final localProducts = productLocalDataSource.getCachedProducts();
      return localProducts.isNotEmpty
          ? Right(localProducts)
          : const Left("No internet connection and no cached data.");
    }
  }

  Future<Either<String, List<ProductModel>>> getPopularProducts() async {
    if (await connectionChecker.isConnected) {
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

        // Use a specific method in your local data source to cache these specifically
        productLocalDataSource.cacheProducts(products: products);

        return Right(products);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      // Retrieve from the specific popular products cache
      final local = productLocalDataSource.getCachedProducts();
      return Right(local);
    }
  }

  Future<Either<String, List<ProductModel>>> getBestProducts() async {
    if (await connectionChecker.isConnected) {
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
    } else {
      final local = productLocalDataSource
          .getCachedProducts()
          .where((p) => p.rating! >= 4)
          .toList();
      return Right(local);
    }
  }

  Future<Either<String, List<ProductModel>>> getBuyAgainProducts() async {
    if (await connectionChecker.isConnected) {
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
    } else {
      final local = productLocalDataSource.getCachedProducts().toList();
      return Right(local);
    }
  }

  Future<Either<String, List<CategoryModel>>> getCategories() async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.get(EndPoints.getCategoriesData);
        final categories = (response['list'] as List)
            .map((e) => CategoryModel.fromMap(e))
            .toList();

        await productLocalDataSource.cacheCategories(categories: categories);
        return Right(categories);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      final local = productLocalDataSource.getCachedCategories();
      return local.isNotEmpty
          ? Right(local)
          : const Left("No internet and no cached categories found.");
    }
  }

  Future<Either<String, List<BrandModel>>> getBrands() async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.get(EndPoints.getBrandsData);
        final brands = (response['list'] as List? ?? [])
            .map((e) => BrandModel.fromMap(e))
            .toList();

        await productLocalDataSource.cacheBrands(brands: brands);
        return Right(brands);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      final local = productLocalDataSource.getCachedBrands();
      return local.isNotEmpty
          ? Right(local)
          : const Left("No internet and no cached brands found.");
    }
  }

  Future<Either<String, List<ProductModel>>> getProductsByBrand({
    required int skip,
    required int limit,
    required String brand,
  }) async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.get(
          EndPoints.getProductsByBrand(brand),
          queryParameters: {"skip": skip, "limit": limit},
        );
        final products = (response['list'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return Right(products);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      final local = productLocalDataSource
          .getCachedProducts()
          .where((p) => p.brand == brand)
          .toList();
      return Right(local);
    }
  }

  Future<Either<String, List<ProductModel>>> getProductsByCategory({
    required int skip,
    required int limit,
    required String category,
  }) async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.get(
          EndPoints.getProductsByCategory(category),
          queryParameters: {"skip": skip, "limit": limit},
        );
        final products = (response['list'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return Right(products);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      final local = productLocalDataSource
          .getCachedProducts()
          .where((p) => p.category == category)
          .toList();
      return Right(local);
    }
  }

  Future<Either<String, List<CategoryNameModel>>> getCategoryNames() async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.get(EndPoints.getCategoryNames);
        final categories = (response['list'] as List)
            .map((e) => CategoryNameModel.fromJson(e))
            .toList();

        await productLocalDataSource.cacheCategoryNames(
          categoryNames: categories,
        );
        return Right(categories);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      final local = productLocalDataSource.getCachedCategoryNames();
      return local.isNotEmpty
          ? Right(local)
          : const Left("No internet and no cached category names found.");
    }
  }

  Future<Either<String, List<ProductModel>>> getFilteredProducts({
    required String search,
    required String priceSort,
    String? category,
  }) async {
    if (await connectionChecker.isConnected) {
      try {
        final response = await api.post(
          EndPoints.getSearchedData,
          data: {
            "search": search,
            "category": category ?? "",
            "skip": 0,
            "limit": 10,
            "price": priceSort,
          },
        );
        final searchedProducts = (response['list'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return Right(searchedProducts);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      var local = productLocalDataSource
          .getCachedProducts()
          .where(
            (p) =>
                p.title != null &&
                p.title!.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
      return Right(local);
    }
  }
}
