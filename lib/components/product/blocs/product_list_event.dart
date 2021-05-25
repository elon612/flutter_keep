part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class ProductListOnLoaded extends ProductListEvent {
  ProductListOnLoaded(this.brandId, this.categoryId);

  final String brandId;
  final String categoryId;

  @override
  List<Object> get props => [brandId, categoryId];
}

class ProductRefreshOnLoaded extends ProductListEvent {
  ProductRefreshOnLoaded();
  @override
  List<Object> get props => [];
}

class ProductMoreListOnLoaded extends ProductListEvent {
  @override
  List<Object> get props => [];
}
