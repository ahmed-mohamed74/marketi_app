
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home_feature/data/repositories/cart_repository.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
    final CartRepository cartRepository;

  AddProductCubit({required this.cartRepository}) : super(AddProductInitial());

  Future<void> addCartProduct({required String id}) async {
    emit(AddCartProductLoading());
    final response = await cartRepository.addCartProduct(id: id);
    response.fold(
      (error) => emit(AddCartProductFailure(errorMessage: error)),
      (message) => emit(AddCartProductSuccess(message)),
    );
  }
}
