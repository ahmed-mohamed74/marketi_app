import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/services/payment/stripe_payment/payment_manager.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';
import 'package:marketi_app/features/order/data/repositories/order_local_service.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final OrderLocalService orderLocalService;
  PaymentCubit({required this.orderLocalService}) : super(PaymentInitial());
  Future<void> makePayment(int amount, String currency) async {
    emit(PaymentLoading());
    try {
      await PaymentManager.makePayment(amount, currency);
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    }
  }

  void saveOrder(OrderModel order) {
    emit(SaveOrderLoading());
    try {
      orderLocalService.saveOrder(order);
      emit(SaveOrderSuccess());
    } catch (e) {
      emit(SaveOrderFailure(errorMessage: e.toString()));
    }
  }
}
