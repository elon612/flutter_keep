part of 'submitting_order_bloc.dart';

abstract class SubmittingOrderEvent extends Equatable {
  const SubmittingOrderEvent();
}

class SubmittingOrderOnLoaded extends SubmittingOrderEvent {
  SubmittingOrderOnLoaded(this.items);
  final List<ShoppingCartItem> items;

  @override
  List<Object> get props => [items];
}

class SubmittingOrderShippingOnChanged extends SubmittingOrderEvent {
  SubmittingOrderShippingOnChanged(this.item);
  final ShippingItem item;

  @override
  List<Object> get props => [item];
}

class SubmittingOrderAddressOnChanged extends SubmittingOrderEvent {
  SubmittingOrderAddressOnChanged(this.address);
  final Address address;

  @override
  List<Object> get props => [address];
}

class SubmittingOrderRemarkOnChanged extends SubmittingOrderEvent {
  SubmittingOrderRemarkOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class SubmittingOrderButtonOnSubmitted extends SubmittingOrderEvent {
  @override
  List<Object> get props => [];
}
