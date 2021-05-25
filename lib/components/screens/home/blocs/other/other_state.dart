part of 'other_bloc.dart';

class OtherState extends Equatable {
  const OtherState(
      {this.page = 1,
      this.status = PageStatus.init,
      this.products = const <Product>[]});

  final int page;

  final PageStatus status;

  final List<Product> products;

  OtherState copyWith({int page, PageStatus status, List<Product> products}) =>
      OtherState(
          page: page ?? this.page,
          status: status ?? this.status,
          products: products ?? this.products);

  @override
  List<Object> get props => [page, status, products];
}
