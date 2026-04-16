part of 'payment_cubit.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentSuccess extends PaymentState {}

final class PaymentFailure extends PaymentState {
  final String errorMessage;

  const PaymentFailure({required this.errorMessage});
}

final class SaveOrderLoading extends PaymentState {}

final class SaveOrderSuccess extends PaymentState {}

final class SaveOrderFailure extends PaymentState {
  final String errorMessage;

  const SaveOrderFailure({required this.errorMessage});
}
