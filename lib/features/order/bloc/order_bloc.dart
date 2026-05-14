import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopsmart/data/repositories/order_repository.dart';
import 'package:shopsmart/features/order/bloc/order_event.dart';
import 'package:shopsmart/features/order/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;
  OrderBloc(this.orderRepository) : super(OrderInitial()) {
    on<PlaceOrderEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        await orderRepository.placeOrder(event.order);

        emit(OrderSuccess());
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });

    on<LoadOrdersEvent>((event, emit) async {
      emit(OrderLoading());

      try {
        final orders = await orderRepository.fetchOrders();

        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError(e.toString()));
      }
    });
  }
}
