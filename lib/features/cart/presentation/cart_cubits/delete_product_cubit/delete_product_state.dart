part of 'delete_product_cubit.dart';

sealed class DeleteProductState extends Equatable {
  const DeleteProductState();

  @override
  List<Object> get props => [];
}

final class DeleteProductInitial extends DeleteProductState {}
final class DeleteCartProductLoading extends DeleteProductState {}

final class DeleteCartProductSuccess extends DeleteProductState {
  final String message;

  const DeleteCartProductSuccess(this.message);
}

final class DeleteCartProductFailure extends DeleteProductState {
  final String errorMessage;

  const DeleteCartProductFailure({required this.errorMessage});
}