part of 'shopping_cart_bloc.dart';

enum ShoppingCartError {
  noError,
  limitExceeded,
}

class ShoppingCartState extends Equatable {
  ShoppingCartState(
      {this.status = PageStatus.init,
      this.items = const <ShoppingCartItem>[],
      this.selected = const <ShoppingCartItem>[],
      this.allChecked = false,
      this.input = const ShoppingCartInput.pure([]),
      this.formzStatus,
      this.error = ShoppingCartError.noError});

  final PageStatus status;

  final List<ShoppingCartItem> items;

  final List<ShoppingCartItem> selected;

  final ShoppingCartInput input;

  final FormzStatus formzStatus;

  final bool allChecked;

  final ShoppingCartError error;

  Stream<ShoppingCartState> copyErrorWithReset(ShoppingCartError error) async* {
    yield copyWith(error: error);
    yield copyWith(error: ShoppingCartError.noError);
  }

  ShoppingCartState copyWith(
          {PageStatus status,
          List<ShoppingCartItem> items,
          List<ShoppingCartItem> selected,
          bool allChecked,
          ShoppingCartInput input,
          FormzStatus formzStatus,
          ShoppingCartError error}) =>
      ShoppingCartState(
        status: status ?? this.status,
        items: items ?? this.items,
        selected: selected ?? this.selected,
        allChecked: allChecked != null ? allChecked : this.allChecked,
        input: input ?? this.input,
        formzStatus: formzStatus ?? this.formzStatus,
        error: error ?? this.error,
      );

  @override
  List<Object> get props =>
      [selected, allChecked, input, status, items, formzStatus, error];
}
