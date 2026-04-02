part of 'home_cubit.dart';

@immutable
class HomeState {
  final List<ProductModel> popularProducts;
  final List<ProductModel> bestProducts;
  final List<ProductModel> buyAgainProducts;
  final List<CategoryBrandModel> categories;
  final List<CategoryBrandModel> brands;
  final bool isLoading;

  const HomeState({
    this.popularProducts = const [],
    this.bestProducts = const [],
    this.buyAgainProducts = const [],
    this.categories = const [],
    this.brands = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    List<ProductModel>? popularProducts,
    List<ProductModel>? bestProducts,
    List<ProductModel>? buyAgainProducts,
    List<CategoryBrandModel>? categories,
    List<CategoryBrandModel>? brands,
    bool? isLoading,
  }) {
    return HomeState(
      popularProducts: popularProducts ?? this.popularProducts,
      bestProducts: bestProducts ?? this.bestProducts,
      buyAgainProducts: buyAgainProducts ?? this.buyAgainProducts,
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final class HomeInitial extends HomeState {}

// GetPopularProducts
final class GetProductsLoading extends HomeState {}

class GetProductsSuccess extends HomeState {
  final List<ProductModel> products;

  const GetProductsSuccess({required this.products});
}

class GetProductsFailure extends HomeState {
  final String errorMessage;

  const GetProductsFailure({required this.errorMessage});
}
