part of 'order_detail_bloc.dart';

class OrderDetailState extends Equatable {
  const OrderDetailState(
      {this.orderId, this.status = PageStatus.init, this.item});

  final String orderId;

  final OrderItem item;

  final PageStatus status;

  OrderDetailState copyWith(
          {String orderId, PageStatus status, OrderItem item}) =>
      OrderDetailState(
        orderId: orderId ?? this.orderId,
        status: status ?? this.status,
        item: item ?? this.item,
      );

  @override
  List<Object> get props => [orderId, status, item];
}
