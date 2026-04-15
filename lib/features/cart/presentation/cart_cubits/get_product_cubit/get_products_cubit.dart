import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:marketi_app/features/cart/data/repositories/cart_repository.dart';

part 'get_products_state.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  final CartRepository cartRepository;
  double amount = 0;
  List<ProductModel> cartList = [];

  GetProductsCubit({required this.cartRepository})
    : super(GetProductsInitial());

  Future<void> getCartProducts() async {
    emit(GetCartProductsLoading());
    final response = await cartRepository.getCartProducts();
    response.fold(
      (error) => emit(GetCartProductsFailure(errorMessage: error)),
      (products) {
        cartList = products;
        for (var p in cartList) {
          p.quantity = 1;
        }
        updateTotalAmount();
        emit(GetCartProductsSuccess(List.from(cartList), amount));
      },
    );
  }

  void updateQuantity(int index, bool isIncrement) {
    final currentProduct = cartList[index];
    int newQuantity = isIncrement
        ? currentProduct.quantity + 1
        : currentProduct.quantity - 1;

    if (newQuantity >= 1) {
      cartList[index] = currentProduct.copyWith(quantity: newQuantity);
      updateTotalAmount();
      emit(GetCartProductsSuccess(List.from(cartList), amount));
    }
  }

  void updateTotalAmount() {
    amount = 0;
    for (var product in cartList) {
      amount += (product.price ?? 0) * product.quantity;
    }
  }
}
