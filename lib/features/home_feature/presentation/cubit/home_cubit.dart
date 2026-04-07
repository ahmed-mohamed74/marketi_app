import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home_feature/data/models/brand_model.dart';
import 'package:marketi_app/features/home_feature/data/models/category_model.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';
import 'package:marketi_app/features/home_feature/data/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit({required this.homeRepository}) : super(HomeState());
  int skip = 0;
  int limit = 10;

  Future<void> getAllProducts({bool loadMore = false}) async {
    if (loadMore) {
      skip += limit; // go to next page
    } else {
      skip = 0; // reset when refreshing
    }

    emit(state.copyWith(allProductsStatus: RequestStatus.loading));

    final response = await homeRepository.getAllProducts(
      skip: skip,
      limit: limit,
    );

    response.fold(
      (error) => emit(
        state.copyWith(
          allProductsStatus: RequestStatus.error,
          allProductsError: error,
        ),
      ),
      (products) {
        final updatedList = loadMore
            ? [...state.allProducts, ...products] // append for pagination
            : products; // replace if refreshing

        emit(
          state.copyWith(
            allProductsStatus: RequestStatus.loaded,
            allProducts: updatedList,
          ),
        );
      },
    );
  }

  Future<void> getPopularProducts() async {
    emit(state.copyWith(popularStatus: RequestStatus.loading));
    final response = await homeRepository.getPopularProducts();
    response.fold(
      (error) => emit(
        state.copyWith(popularStatus: RequestStatus.error, popularError: error),
      ),
      (products) => emit(
        state.copyWith(
          popularStatus: RequestStatus.loaded,
          popularProducts: products,
        ),
      ),
    );
  }

  Future<void> getBestProducts() async {
    emit(state.copyWith(bestStatus: RequestStatus.loading));
    final response = await homeRepository.getBestProducts();
    response.fold(
      (error) => emit(
        state.copyWith(bestStatus: RequestStatus.error, bestError: error),
      ),
      (products) => emit(
        state.copyWith(
          bestStatus: RequestStatus.loaded,
          bestProducts: products,
        ),
      ),
    );
  }

  Future<void> getBuyAgainProducts() async {
    emit(state.copyWith(buyAgainStatus: RequestStatus.loading));
    final response = await homeRepository.getBuyAgainProducts();
    response.fold(
      (error) => emit(
        state.copyWith(
          buyAgainStatus: RequestStatus.error,
          buyAgainError: error,
        ),
      ),
      (products) => emit(
        state.copyWith(
          buyAgainStatus: RequestStatus.loaded,
          buyAgainProducts: products,
        ),
      ),
    );
  }

  Future<void> getCategories() async {
    emit(state.copyWith(categoriesStatus: RequestStatus.loading));
    final response = await homeRepository.getCategories();
    response.fold(
      (error) => emit(
        state.copyWith(
          categoriesStatus: RequestStatus.error,
          categoriesError: error,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          categoriesStatus: RequestStatus.loaded,
          categories: categories,
        ),
      ),
    );
  }

  Future<void> getBrands() async {
    emit(state.copyWith(brandsStatus: RequestStatus.loading));
    final response = await homeRepository.getBrands();
    response.fold(
      (error) => emit(
        state.copyWith(brandsStatus: RequestStatus.error, brandsError: error),
      ),
      (brands) => emit(
        state.copyWith(brandsStatus: RequestStatus.loaded, brands: brands),
      ),
    );
  }
}
