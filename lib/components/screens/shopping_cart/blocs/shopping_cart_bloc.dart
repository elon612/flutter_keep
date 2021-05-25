import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/components/screens/shopping_cart/formz/formz.dart';
import 'package:flutter_keep/components/screens/shopping_cart/formz/shopping_cart_input.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:formz/formz.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  ShoppingCartBloc({UserRepository repository})
      : assert(repository != null),
        _userRepository = repository,
        super(ShoppingCartState()) {
    _streamSubscription = _userRepository.notify.listen((_) {
      add(ShoppingCartOnRefresh());
    });
  }

  final UserRepository _userRepository;

  StreamSubscription<void> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ShoppingCartState> mapEventToState(
    ShoppingCartEvent event,
  ) async* {
    if (event is ShoppingCartOnLoaded) {
      yield* _mapCartOnLoadedToState();
    } else if (event is ShoppingCartOnRefresh) {
      final List<ShoppingCartItem> items = await _userRepository.shoppingCarts;
      yield state.copyWith(items: items, selected: [], allChecked: false);
    } else if (event is ShoppingCartItemCheckOnToggled) {
      yield* _mapItemCheckOnToggledToState(event);
    } else if (event is ShoppingCartItemPlusNumberOnPressed) {
      yield* _mapPlusNumberOnPressedToState(event);
    } else if (event is ShoppingCartItemMinusNumberOnPressed) {
      yield* _mapMinusNumberOnPressedToState(event);
    } else if (event is ShoppingCartAllCheckOnToggled) {
      yield* _mapAllCheckOnToggledToState();
    } else if (event is ShoppingCartOnSubmitted) {
      yield* _mapCartOnSubmittedToState();
    } else if (event is ShoppingCartItemOnDeleted) {
      yield* _mapItemOnDeletedToState(event);
    }
  }

  Stream<ShoppingCartState> _mapAllCheckOnToggledToState() async* {
    final bool allChecked = !state.allChecked;
    yield state.copyWith(
        allChecked: allChecked,
        selected: allChecked ? state.items : const <ShoppingCartItem>[]);
  }

  Stream<ShoppingCartState> _mapCartOnSubmittedToState() async* {
    final validated = ShoppingCartInput.dirty(state.selected);
    final FormzStatus formzStatus = Formz.validate([validated]);
    yield state.copyWith(input: validated, formzStatus: formzStatus);
    if (formzStatus.isValidated) {
      yield state.copyWith(formzStatus: FormzStatus.submissionSuccess);
      yield state.copyWith(input: ShoppingCartInput.pure(state.selected));
    } else {
      yield state.copyWith(input: ShoppingCartInput.pure(state.selected));
    }
  }

  Stream<ShoppingCartState> _mapItemOnDeletedToState(
      ShoppingCartItemOnDeleted event) async* {
    final item = event.item;
    await _userRepository.deleteCart(item.cartId);
    final items = state.items.where((e) => e != item).toList();
    final selected = state.selected.where((e) => e != item).toList();
    yield state.copyWith(items: items, selected: selected);
  }

  Stream<ShoppingCartState> _mapMinusNumberOnPressedToState(
      ShoppingCartItemMinusNumberOnPressed event) async* {
    final item = event.item;
    int number = item.number - 1;
    if (number <= 0) number = 1;
    yield* _mapItemNumberOnPressedToState(item, number);
  }

  Stream<ShoppingCartState> _mapPlusNumberOnPressedToState(
      ShoppingCartItemPlusNumberOnPressed event) async* {
    final ShoppingCartItem item = event.item;
    final int number = item.number + 1;
    yield* _mapItemNumberOnPressedToState(item, number);
  }

  Stream<ShoppingCartState> _mapItemNumberOnPressedToState(
      ShoppingCartItem item, int number) async* {
    final exist = state.selected.indexOf(item) != -1;
    try {
      await _userRepository.updateCart(item.cartId, item.skuId, number);
      final newItem = item.copyWith(number: number);
      final items = state.items
          .map((e) => e.prdId != newItem.prdId ? e : newItem)
          .toList();
      final selected = exist
          ? state.selected
              .map((e) => e.prdId == newItem.prdId ? newItem : e)
              .toList()
          : state.selected;
      yield state.copyWith(items: items, selected: selected);
    } on LimitExceededException catch (_) {
      yield* state.copyErrorWithReset(ShoppingCartError.limitExceeded);
    }
  }

  Stream<ShoppingCartState> _mapItemCheckOnToggledToState(
      ShoppingCartItemCheckOnToggled event) async* {
    final item = event.item;
    if (state.selected.indexOf(item) == -1) {
      yield state.copyWith(selected: [...state.selected, item]);
    } else {
      yield state.copyWith(
          selected:
              state.selected.where((element) => element != item).toList());
    }
  }

  Stream<ShoppingCartState> _mapCartOnLoadedToState() async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final List<ShoppingCartItem> items = await _userRepository.shoppingCarts;
    yield state.copyWith(status: PageStatus.success, items: items);
  }
}
