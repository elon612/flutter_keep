part of 'shopping_cart_sheet_bloc.dart';

enum ShoppingCartSheetError { noError, unauthenticated, empty, invalid }

class ShoppingCartSheetState extends Equatable {
  const ShoppingCartSheetState(
      {this.skus = const [],
      this.items = const [],
      this.selected = const [],
      this.info,
      this.number = 1,
      this.disableItems = const [],
      this.selectedSku,
      this.snapshot = const AsyncSnapshot.nothing(),
      this.error = ShoppingCartSheetError.noError,
      this.authenticationStatus});

  final AsyncSnapshot snapshot;

  final List<Sku> skus;

  final List<SkuItems> items;

  final ProductDetailInfo info;

  final int number;

  final Sku selectedSku;

  final List<SkuItem> selected;

  final List<SkuItem> disableItems;

  final ShoppingCartSheetError error;

  final AuthenticationStatus authenticationStatus;

  Stream<ShoppingCartSheetState> copyErrorWithReset(
      ShoppingCartSheetError error) async* {
    yield this.copyWith(error: error);
    yield this.copyWith(error: ShoppingCartSheetError.noError);
  }

  ShoppingCartSheetState copyWith(
          {List<Sku> skus,
          List<SkuItems> items,
          List<SkuItem> selected,
          List<SkuItem> disableItems,
          ProductDetailInfo info,
          int number,
          AsyncSnapshot snapshot,
          Sku selectedSku,
          ShoppingCartSheetError error,
          AuthenticationStatus authenticationStatus}) =>
      ShoppingCartSheetState(
          skus: skus ?? this.skus,
          items: items ?? this.items,
          info: info ?? this.info,
          selected: selected ?? this.selected,
          disableItems: disableItems ?? this.disableItems,
          snapshot: snapshot ?? this.snapshot,
          number: number ?? this.number,
          selectedSku: selectedSku ?? this.selectedSku,
          error: error ?? this.error,
          authenticationStatus:
              authenticationStatus ?? this.authenticationStatus);

  @override
  List<Object> get props => [
        skus,
        items,
        info,
        selected,
        snapshot,
        disableItems,
        number,
        selectedSku,
        error,
        authenticationStatus,
      ];
}
