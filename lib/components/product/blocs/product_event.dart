part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class ProductOnLoaded extends ProductEvent {
  final String productId;
  ProductOnLoaded(this.productId);

  @override
  List<Object> get props => [productId];
}

class ProductCollectionOnClicked extends ProductEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationStatusOnChanged extends ProductEvent {
  AuthenticationStatusOnChanged(this.status);
  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
