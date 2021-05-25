import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc(
      {ProductRepository repository, RefreshController refreshController})
      : assert(repository != null),
        assert(refreshController != null),
        _repository = repository,
        _refreshController = refreshController,
        super(ProductListState());

  final ProductRepository _repository;

  final RefreshController _refreshController;

  @override
  Stream<ProductListState> mapEventToState(
    ProductListEvent event,
  ) async* {
    if (event is ProductListOnLoaded) {
      yield* _mapProductOnLoadedToState(event);
    } else if (event is ProductRefreshOnLoaded) {
      yield* _mapProductRefreshOnLoaded();
    } else if (event is ProductMoreListOnLoaded) {
      yield* _mapMoreListOnLoadedToState();
    }
  }

  Stream<ProductListState> _mapProductRefreshOnLoaded() async* {
    final page = 1;
    try {
      final List<Product> products = await _repository.getProductsBy(
          page: page, categoryId: state.categoryId, brandId: state.brandId);
      final categories = await _repository.getBrandCategories(state.brandId);
      _refreshController.refreshCompleted();
      yield state.copyWith(
          result: ListResult(products: products, categories: categories),
          page: page);
    } catch (_) {}
  }

  Stream<ProductListState> _mapProductOnLoadedToState(
      ProductListOnLoaded event) async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final String brandId = event.brandId;
    final String categoryId = event.categoryId;

    try {
      final products = await _repository.getProductsBy(
          brandId: brandId, categoryId: categoryId, page: state.page);
      final categories = await _repository.getBrandCategories(brandId);
      yield state.copyWith(
          status: PageStatus.success,
          result: ListResult(products: products, categories: categories),
          categoryId: categoryId,
          brandId: brandId);
    } catch (e) {}
  }

  Stream<ProductListState> _mapMoreListOnLoadedToState() async* {
    final page = state.page + 1;
    try {
      final List<Product> products = await _repository.getProductsBy(
          categoryId: state.categoryId, brandId: state.brandId, page: page);
      final merged = state.result
          .copyWith(products: [...state.result.products, ...products]);
      _refreshController.loadComplete();
      yield state.copyWith(result: merged, page: page);
    } catch (_) {
      _refreshController.loadComplete();
    }
  }
}
