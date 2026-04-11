
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home_feature/data/repositories/cart_repository.dart';

part 'delete_product_state.dart';

class DeleteProductCubit extends Cubit<DeleteProductState> {
    final CartRepository cartRepository;

  DeleteProductCubit({required this.cartRepository}) : super(DeleteProductInitial());

  Future<void> deleteCartProduct({required String id}) async {
    emit(DeleteCartProductLoading());
    final response = await cartRepository.deleteCartProduct(id: id);
    response.fold(
      (error) => emit(DeleteCartProductFailure(errorMessage: error)),
      (message) => emit(DeleteCartProductSuccess(message)),
    );
  }
}
