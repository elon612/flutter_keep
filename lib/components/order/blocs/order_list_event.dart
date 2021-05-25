part of 'order_list_bloc.dart';

abstract class OrderListEvent extends Equatable {
  const OrderListEvent();
}

class OrderListOnLoaded extends OrderListEvent {

  OrderListOnLoaded(this.type);
  final OrderType type;

  @override
  List<Object> get props => [type];
}

class OrderListOnPulled extends OrderListEvent {
  @override
  List<Object> get props => [];
}

class OrderListOnCanceled extends OrderListEvent {

  OrderListOnCanceled(this.item);
  final OrderItem item;

  @override
  List<Object> get props => [item];
}
