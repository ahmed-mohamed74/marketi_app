import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home_feature/view_model/models/category_model.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';
import 'package:marketi_app/features/home_feature/view_model/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  HomeCubit({required this.homeRepository}) : super(HomeState());
  Future<void> getPopularProducts() async {
    // emit(GetProductsLoading());
    final response = await homeRepository.getPopularProducts();
    response.fold(
      (errorMessage) {},
      (response) => emit(state.copyWith(popularProducts: response)),
    );
  }

  Future<void> getBestProducts() async {
    // emit(GetProductsLoading());
    final response = await homeRepository.getBestProducts();
    response.fold(
      (errorMessage) {},
      (response) => emit(state.copyWith(bestProducts: response)),
    );
  }

  Future<void> getBuyAgainProducts() async {
    // emit(GetProductsLoading());
    final response = await homeRepository.getBuyAgainProducts();
    response.fold(
      (errorMessage) {},
      (response) => emit(state.copyWith(buyAgainProducts: response)),
    );
  }

  Future<void> getCategories() async {
    // emit(GetProductsLoading());
    final response = await homeRepository.getCategories();
    response.fold(
      (errorMessage) {},
      (response) => emit(state.copyWith(categories: response)),
    );
  }

  Future<void> getBrands() async {
    // emit(GetProductsLoading());
    final response = await homeRepository.getBrands();
    response.fold(
      (errorMessage) {},
      (response) => emit(state.copyWith(brands: response)),
    );
  }
}
