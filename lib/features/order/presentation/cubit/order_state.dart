part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderSuccess extends OrderState {
  final List<OrderModel> orders;

  const OrderSuccess({required this.orders});
}

final class OrderFailure extends OrderState {
  final String errorMessage;

  const OrderFailure({required this.errorMessage});
}
