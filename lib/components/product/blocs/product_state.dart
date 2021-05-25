part of 'product_bloc.dart';

enum ProductError {
  noError,
  noAuth,
}

class ProductState extends Equatable {
  ProductState(
      {this.status = PageStatus.init,
      this.detailInfo,
      this.collected,
      this.productId,
      this.authStatus,
      this.error = ProductError.noError});

  final bool collected;

  final String productId;

  final PageStatus status;

  final ProductError error;

  final ProductDetailInfo detailInfo;

  final AuthenticationStatus authStatus;

  Stream<ProductState> copyErrorWithReset(ProductError error) async* {
    yield copyWith(error: error);
    yield copyWith(error: ProductError.noError);
  }

  ProductState copyWith(
          {bool collected,
          ProductDetailInfo detailInfo,
          PageStatus status,
          String productId,
          ProductError error,
          AuthenticationStatus authStatus}) =>
      ProductState(
        detailInfo: detailInfo ?? this.detailInfo,
        collected: collected != null ? collected : this.collected,
        productId: productId ?? this.productId,
        status: status ?? this.status,
        error: error ?? this.error,
        authStatus: authStatus ?? this.authStatus,
      );

  @override
  List<Object> get props =>
      [detailInfo, collected, productId, status, authStatus, error];
}
