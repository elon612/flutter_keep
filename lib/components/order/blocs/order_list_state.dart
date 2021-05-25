part of 'order_list_bloc.dart';

class OrderListState extends Equatable {
  const OrderListState(
      {this.page = 1,
      this.type,
      this.status = PageStatus.init,
      this.items = const []});

  final int page;

  final OrderType type;

  final PageStatus status;

  final List<OrderItem> items;

  OrderListState copyWith(
          {int page,
          OrderType type,
          PageStatus status,
          List<OrderItem> items}) =>
      OrderListState(
        page: page ?? this.page,
        type: type ?? this.type,
        status: status ?? this.status,
        items: items ?? this.items,
      );

  @override
  List<Object> get props => [page, type, status, items];
}
