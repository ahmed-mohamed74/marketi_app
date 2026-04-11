part of 'add_product_cubit.dart';

sealed class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object> get props => [];
}

final class AddProductInitial extends AddProductState {}


final class AddCartProductLoading extends AddProductState {}

final class AddCartProductSuccess extends AddProductState {
  final String message;

  const AddCartProductSuccess(this.message);
}

final class AddCartProductFailure extends AddProductState {
  final String errorMessage;

  const AddCartProductFailure({required this.errorMessage});
}
