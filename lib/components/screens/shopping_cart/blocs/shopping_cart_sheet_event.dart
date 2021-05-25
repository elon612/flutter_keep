part of 'shopping_cart_sheet_bloc.dart';

abstract class ShoppingCartSheetEvent extends Equatable {
  const ShoppingCartSheetEvent();
}

class ShoppingCartSheetOnLoaded extends ShoppingCartSheetEvent {
  ShoppingCartSheetOnLoaded(this.skus, this.items, this.info);

  final List<Sku> skus;
  final List<SkuItems> items;
  final ProductDetailInfo info;

  @override
  List<Object> get props => [skus, items, info];
}

class ShoppingCartSheetSkuItemOnClicked extends ShoppingCartSheetEvent {
  ShoppingCartSheetSkuItemOnClicked(this.item);
  final SkuItem item;

  @override
  List<Object> get props => [item];
}

class ShoppingCartSheetNumberPlusOnClicked extends ShoppingCartSheetEvent {
  @override
  List<Object> get props => [];
}

class ShoppingCartSheetNumberMinusOnClicked extends ShoppingCartSheetEvent {
  @override
  List<Object> get props => [];
}

class ShoppingCartSheetButtonOnClicked extends ShoppingCartSheetEvent {
  @override
  List<Object> get props => [];
}
