part of 'get_products_cubit.dart';

sealed class GetProductsState extends Equatable {
  const GetProductsState();

  @override
  List<Object> get props => [];
}

final class GetProductsInitial extends GetProductsState {}


final class GetCartProductsLoading extends GetProductsState {}

final class GetCartProductsSuccess extends GetProductsState {
  final List<ProductModel> cartProducts;

  const GetCartProductsSuccess(this.cartProducts);
}

final class GetCartProductsFailure extends GetProductsState {
  final String errorMessage;

  const GetCartProductsFailure({required this.errorMessage});
}

