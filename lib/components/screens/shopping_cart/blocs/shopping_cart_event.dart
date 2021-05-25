part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [];
}

class ShoppingCartOnLoaded extends ShoppingCartEvent {}

class ShoppingCartOnRefresh extends ShoppingCartEvent {}

class ShoppingCartAllCheckOnToggled extends ShoppingCartEvent {}

class ShoppingCartOnSubmitted extends ShoppingCartEvent {}

class ShoppingCartItemPlusNumberOnPressed extends ShoppingCartEvent {
  ShoppingCartItemPlusNumberOnPressed(this.item);
  final ShoppingCartItem item;

  @override
  List<Object> get props => [item];
}

class ShoppingCartItemMinusNumberOnPressed extends ShoppingCartEvent {
  ShoppingCartItemMinusNumberOnPressed(this.item);
  final ShoppingCartItem item;

  @override
  List<Object> get props => [item];
}

class ShoppingCartItemCheckOnToggled extends ShoppingCartEvent {
  ShoppingCartItemCheckOnToggled(this.item);
  final ShoppingCartItem item;

  @override
  List<Object> get props => [item];
}

class ShoppingCartItemOnDeleted extends ShoppingCartEvent {
  ShoppingCartItemOnDeleted(this.item);
  final ShoppingCartItem item;

  @override
  List<Object> get props => [item];
}
