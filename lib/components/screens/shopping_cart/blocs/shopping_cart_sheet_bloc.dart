import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'shopping_cart_sheet_event.dart';
part 'shopping_cart_sheet_state.dart';

class ShoppingCartSheetBloc
    extends Bloc<ShoppingCartSheetEvent, ShoppingCartSheetState> {
  ShoppingCartSheetBloc({UserRepository repository, AuthenticationBloc bloc})
      : assert(repository != null),
        _repository = repository,
        super(ShoppingCartSheetState(authenticationStatus: bloc.state.status));

  final UserRepository _repository;

  @override
  Stream<ShoppingCartSheetState> mapEventToState(
    ShoppingCartSheetEvent event,
  ) async* {
    if (event is ShoppingCartSheetOnLoaded) {
      yield state.copyWith(
          skus: event.skus,
          items: event.items,
          info: event.info,
          snapshot: AsyncSnapshot.nothing());
    } else if (event is ShoppingCartSheetSkuItemOnClicked) {
      yield* _mapSheetSkuItemOnClickedToState(event);
    } else if (event is ShoppingCartSheetNumberPlusOnClicked) {
      yield* _mapSheetNumberOnChangedToState(state.number + 1);
    } else if (event is ShoppingCartSheetNumberMinusOnClicked) {
      yield* _mapSheetNumberOnChangedToState(state.number - 1);
    } else if (event is ShoppingCartSheetButtonOnClicked) {
      yield* _mapButtonOnClickedToState();
    }
  }

  Stream<ShoppingCartSheetState> _mapButtonOnClickedToState() async* {
    if (state.authenticationStatus != AuthenticationStatus.authenticated) {
      yield* state.copyErrorWithReset(ShoppingCartSheetError.unauthenticated);
      return;
    }
    if (state.selectedSku != null) {
      yield state.copyWith(snapshot: AsyncSnapshot.waiting());
      try {
        await _repository.toCart(state.selectedSku.id, state.number, '1');
        yield state.copyWith(
            snapshot: AsyncSnapshot.withData(ConnectionState.done, true));
      } on LimitExceededException catch (_) {
        yield* state.copyErrorWithReset(ShoppingCartSheetError.invalid);
        yield state.copyWith(snapshot: AsyncSnapshot.nothing());
      }
    } else {
      yield* state.copyErrorWithReset(ShoppingCartSheetError.empty);
    }
  }

  Stream<ShoppingCartSheetState> _mapSheetNumberOnChangedToState(
      int update) async* {
    if (state.selectedSku == null) {
      yield* state.copyErrorWithReset(ShoppingCartSheetError.empty);
    } else if (update <= 0 || update > state.selectedSku.stock) {
      yield* state.copyErrorWithReset(ShoppingCartSheetError.invalid);
    } else {
      yield state.copyWith(number: update, snapshot: AsyncSnapshot.nothing());
    }
  }

  Stream<ShoppingCartSheetState> _mapSheetSkuItemOnClickedToState(
      ShoppingCartSheetSkuItemOnClicked event) async* {
    Sku sku;
    List<SkuItem> selected;
    final SkuItem item = event.item;

    if (state.selected.contains(item)) {
      selected = state.selected.where((e) => e != item).toList();
    } else {
      final int index = _findItemGroup(item);
      final SkuItem sameGroupItem = _getSameGroupItem(index);
      if (sameGroupItem == null) {
        selected = [...state.selected, item];
      } else {
        final List<SkuItem> update =
            state.selected.where((e) => e != sameGroupItem).toList();
        selected = [...update, item];
      }
    }

    if (state.items.length == selected.length) {
      final List<int> ids = selected.map((e) => e.id).toList();
      ids.sort();
      final String key = ids.join('|');
      sku = state.skus.firstWhere((e) => e.key == key, orElse: () => null);
    }

    final List<SkuItem> disabled = _filteredDisableSkuItem(selected);
    yield state.copyWith(
        selected: selected,
        disableItems: disabled,
        selectedSku: sku,
        snapshot: AsyncSnapshot.nothing(),
        number: 1);
  }

  /// 根据 已选的 [SkuItem] 数组，筛选出不能选择的 [SkuItem]
  List<SkuItem> _filteredDisableSkuItem(List<SkuItem> items) {
    final List<SkuItem> disableItems = <SkuItem>[];
    final List<String> selected = items.map((e) => e.id.toString()).toList();
    final List<Sku> soldOut = state.skus
        .where((e) => selected.any((i) => e.key.contains(i)) && e.stock == 0)
        .toList();

    final Set<int> keys = soldOut
        .map((e) => e.key.split('|'))
        .expand((e) => e)
        .map((e) => int.tryParse(e))
        .toSet();
    final List<SkuItem> skuItems = state.items.expand((e) => e.items).toList();
    final List<SkuItem> filtered = skuItems
        .where((e) => keys.contains(e.id) && !items.contains(e))
        .toList();

    disableItems.addAll(filtered);

    return disableItems;
  }

  /// 查询 [item] 是属于那个分组的
  int _findItemGroup(SkuItem item) =>
      state.items.indexWhere((e) => e.items.contains(item));

  /// 判断是否有同组的属性被选择
  SkuItem _getSameGroupItem(int index) => state.items[index].items
      .firstWhere((e) => state.selected.contains(e), orElse: () => null);
}
