import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/dummy_data.dart';
import 'package:marketi_app/features/home_feature/view_model/models/brand_model.dart';
import 'package:marketi_app/features/home_feature/view_model/models/category_model.dart';
import 'package:marketi_app/features/home_feature/view_model/models/product_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
  void getPopularProducts() {
    try {
      // emit(GetProductsLoading());
      final response = DummyData.products;
      emit(state.copyWith(popularProducts: response));
    } catch (e) {
      // emit(GetProductsFailure(errorMessage: e.toString()));
    }
  }

  void getBestProducts() {
    try {
      // emit(GetProductsLoading());
      final response = DummyData.bestproducts;
      emit(state.copyWith(bestProducts: response));
    } catch (e) {
      // emit(GetProductsFailure(errorMessage: e.toString()));
    }
  }

  void getBuyAgainProducts() {
    try {
      // emit(GetProductsLoading());
      final response = DummyData.buyAgainProducts;
      emit(state.copyWith(buyAgainProducts: response));
    } catch (e) {
      // emit(GetProductsFailure(errorMessage: e.toString()));
    }
  }

  void getCategories() {
    try {
      // emit(GetProductsLoading());
      final response = DummyData.categories;
      emit(state.copyWith(categories: response));
    } catch (e) {
      // emit(GetProductsFailure(errorMessage: e.toString()));
    }
  }

   void getBrands() {
    try {
      // emit(GetProductsLoading());
      final response = DummyData.brands;
      emit(state.copyWith(brands: response));
    } catch (e) {
      // emit(GetProductsFailure(errorMessage: e.toString()));
    }
  }
}
