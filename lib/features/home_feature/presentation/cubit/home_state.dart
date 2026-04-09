part of 'home_cubit.dart';

enum RequestStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final List<ProductModel> popularProducts;
  final List<ProductModel> allProducts;
  final List<ProductModel> productsByCategory;
  final List<ProductModel> productsByBrand;
  final List<ProductModel> bestProducts;
  final List<ProductModel> buyAgainProducts;
  final List<CategoryModel> categories;
  final List<BrandModel> brands;

  final RequestStatus allProductsStatus;
  final RequestStatus popularStatus;
  final RequestStatus productsByCategoryStatus;
  final RequestStatus productsByBrandStatus;
  final RequestStatus bestStatus;
  final RequestStatus buyAgainStatus;
  final RequestStatus categoriesStatus;
  final RequestStatus brandsStatus;

  final String? allProductsError;
  final String? popularError;
  final String? productsByCategoryError;
  final String? productsByBrandError;
  final String? bestError;
  final String? buyAgainError;
  final String? categoriesError;
  final String? brandsError;

  const HomeState({
    this.popularProducts = const [],
    this.allProducts = const [],
    this.productsByCategory = const [],
    this.productsByBrand = const [],
    this.bestProducts = const [],
    this.buyAgainProducts = const [],
    this.categories = const [],
    this.brands = const [],
    this.popularStatus = RequestStatus.initial,
    this.allProductsStatus = RequestStatus.initial,
    this.productsByCategoryStatus = RequestStatus.initial,
    this.productsByBrandStatus = RequestStatus.initial,
    this.bestStatus = RequestStatus.initial,
    this.buyAgainStatus = RequestStatus.initial,
    this.categoriesStatus = RequestStatus.initial,
    this.brandsStatus = RequestStatus.initial,
    this.popularError,
    this.bestError,
    this.buyAgainError,
    this.categoriesError,
    this.brandsError,
    this.allProductsError,
    this.productsByCategoryError,
    this.productsByBrandError,
  });

  HomeState copyWith({
    List<ProductModel>? popularProducts,
    List<ProductModel>? allProducts,
    List<ProductModel>? productsByCategory,
    List<ProductModel>? productsByBrand,
    List<ProductModel>? bestProducts,
    List<ProductModel>? buyAgainProducts,
    List<CategoryModel>? categories,
    List<BrandModel>? brands,
    RequestStatus? allProductsStatus,
    RequestStatus? productsByCategoryStatus,
    RequestStatus? productsByBrandStatus,
    RequestStatus? popularStatus,
    RequestStatus? bestStatus,
    RequestStatus? buyAgainStatus,
    RequestStatus? categoriesStatus,
    RequestStatus? brandsStatus,
    String? allProductsError,
    String? productsByCategoryError,
    String? productsByBrandError,
    String? popularError,
    String? bestError,
    String? buyAgainError,
    String? categoriesError,
    String? brandsError,
  }) {
    return HomeState(
      popularProducts: popularProducts ?? this.popularProducts,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      productsByBrand: productsByBrand ?? this.productsByBrand,
      allProducts: allProducts ?? this.allProducts,
      bestProducts: bestProducts ?? this.bestProducts,
      buyAgainProducts: buyAgainProducts ?? this.buyAgainProducts,
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      popularStatus: popularStatus ?? this.popularStatus,
      allProductsStatus: allProductsStatus ?? this.allProductsStatus,
      productsByCategoryStatus:
          productsByCategoryStatus ?? this.productsByCategoryStatus,
      productsByBrandStatus:
          productsByBrandStatus ?? this.productsByBrandStatus,
      bestStatus: bestStatus ?? this.bestStatus,
      buyAgainStatus: buyAgainStatus ?? this.buyAgainStatus,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      brandsStatus: brandsStatus ?? this.brandsStatus,
      popularError: popularError ?? this.popularError,
      allProductsError: allProductsError ?? this.allProductsError,
      productsByCategoryError:
          productsByCategoryError ?? this.productsByCategoryError,
      productsByBrandError: productsByBrandError ?? this.productsByBrandError,
      bestError: bestError ?? this.bestError,
      buyAgainError: buyAgainError ?? this.buyAgainError,
      categoriesError: categoriesError ?? this.categoriesError,
      brandsError: brandsError ?? this.brandsError,
    );
  }

  @override
  List<Object?> get props => [
    popularProducts,
    allProducts,
    productsByCategory,
    productsByBrand,
    bestProducts,
    buyAgainProducts,
    categories,
    brands,
    allProductsStatus,
    productsByCategoryStatus,
    productsByBrandStatus,
    popularStatus,
    bestStatus,
    buyAgainStatus,
    categoriesStatus,
    brandsStatus,
    allProductsError,
    productsByCategoryError,
    productsByBrandError,
    popularError,
    bestError,
    buyAgainError,
    categoriesError,
    brandsError,
  ];
}
