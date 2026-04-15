import 'package:hive/hive.dart';
import 'package:marketi_app/features/home/data/models/brand_model.dart';
import 'package:marketi_app/features/home/data/models/category_model.dart';
import 'package:marketi_app/features/home/data/models/category_name_model.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';

class ProductLocalDataSource {
  final Box<ProductModel> productBox;
  final Box<CategoryModel> categoryBox;
  final Box<BrandModel> brandBox;
  final Box<CategoryNameModel> categoryNameBox;
  final Box<ProductModel> cartBox;
  final Box<ProductModel> favoriteBox;

  ProductLocalDataSource({
    required this.productBox,
    required this.categoryBox,
    required this.brandBox,
    required this.categoryNameBox,
    required this.cartBox,
    required this.favoriteBox,
  });

  // --- Products ---
  Future<void> cacheProducts({required List<ProductModel> products}) async {
    await productBox.clear();
    final dataMap = {for (var p in products) p.id.toString(): p};
    await productBox.putAll(dataMap);
  }

  List<ProductModel> getCachedProducts() => productBox.values.toList();

  // --- Categories ---
  Future<void> cacheCategories({required List<CategoryModel> categories}) async {
    await categoryBox.clear();
    await categoryBox.addAll(categories);
  }

  List<CategoryModel> getCachedCategories() => categoryBox.values.toList();

  // --- Brands ---
  Future<void> cacheBrands({required List<BrandModel> brands}) async {
    await brandBox.clear();
    await brandBox.addAll(brands);
  }

  List<BrandModel> getCachedBrands() => brandBox.values.toList();

  // --- Category Names ---
  Future<void> cacheCategoryNames({required List<CategoryNameModel> categoryNames}) async {
    await categoryNameBox.clear();
    await categoryNameBox.addAll(categoryNames);
  }

  List<CategoryNameModel> getCachedCategoryNames() => categoryNameBox.values.toList();
  
  // --- Cart ---
  Future<void> cacheCartProducts({required List<ProductModel> products}) async {
    await cartBox.clear();
    final dataMap = {for (var p in products) p.id.toString(): p};
    await cartBox.putAll(dataMap);
  }

  List<ProductModel> getCachedCartProducts() => cartBox.values.toList();

  // --- Favorites ---
  Future<void> cacheFavoriteProducts({required List<ProductModel> products}) async {
    await favoriteBox.clear();
    final dataMap = {for (var p in products) p.id.toString(): p};
    await favoriteBox.putAll(dataMap);
  }

  List<ProductModel> getCachedFavoriteProducts() => favoriteBox.values.toList();
}