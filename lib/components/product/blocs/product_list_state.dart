part of 'product_list_bloc.dart';

class ProductListState extends Equatable {
  const ProductListState(
      {this.page = 1,
      this.brandId,
      this.categoryId,
      this.status = PageStatus.init,
      this.result});

  final int page;

  final String brandId;

  final String categoryId;

  final PageStatus status;

  final ListResult result;

  ProductListState copyWith(
          {int page,
          String brandId,
          String categoryId,
          PageStatus status,
          ListResult result}) =>
      ProductListState(
          page: page ?? this.page,
          categoryId: categoryId ?? this.categoryId,
          brandId: brandId ?? this.brandId,
          status: status ?? this.status,
          result: result ?? this.result);

  @override
  List<Object> get props => [categoryId, brandId, page, status, result];
}
