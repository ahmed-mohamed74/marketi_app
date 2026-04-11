
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';
import 'package:marketi_app/features/home_feature/data/repositories/cart_repository.dart';

part 'get_products_state.dart';

class GetProductsCubit extends Cubit<GetProductsState> {
  final CartRepository cartRepository;

  GetProductsCubit({required this.cartRepository}) : super(GetProductsInitial());

  Future<void> getCartProducts() async {
    emit(GetCartProductsLoading());
    final response = await cartRepository.getCartProducts();
    response.fold(
      (error) => emit(GetCartProductsFailure(errorMessage: error)),
      (products) => emit(GetCartProductsSuccess(products)),
    );
  }
}
