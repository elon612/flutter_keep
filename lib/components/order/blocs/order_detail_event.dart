part of 'order_detail_bloc.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();
}

class OrderDetailOnLoaded extends OrderDetailEvent {

  OrderDetailOnLoaded(this.orderId);
  final String orderId;

  @override
  List<Object> get props => [orderId];
}