import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/services/payment/stripe_payment/payment_manager.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  Future<void> makePayment(int amount, String currency) async {
    emit(PaymentLoading());
    try {
      await PaymentManager.makePayment(amount, currency);
      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentFailure(errorMessage: e.toString()));
    }
  }
}
