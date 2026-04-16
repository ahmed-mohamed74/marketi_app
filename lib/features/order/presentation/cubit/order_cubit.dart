import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';
import 'package:marketi_app/features/order/data/repositories/order_local_service.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderLocalService orderLocalService;
  OrderCubit({required this.orderLocalService}) : super(OrderInitial());
  void getAllOrders() {
    emit(OrderLoading());
    try {
      final orders = orderLocalService.getAllOrders();
      emit(OrderSuccess(orders: orders));
    } catch (e) {
      emit(OrderFailure(errorMessage: e.toString()));
    }
  }
  
}
