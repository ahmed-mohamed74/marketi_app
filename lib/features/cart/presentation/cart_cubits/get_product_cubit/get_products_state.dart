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
  final double totalAmount;

  const GetCartProductsSuccess(this.cartProducts, this.totalAmount);
  @override
  List<Object> get props => [cartProducts, totalAmount];
}

final class GetCartProductsFailure extends GetProductsState {
  final String errorMessage;

  const GetCartProductsFailure({required this.errorMessage});
}

