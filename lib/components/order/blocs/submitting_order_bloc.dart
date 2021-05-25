import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/models/shipping_item.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:formz/formz.dart';

part 'submitting_order_event.dart';
part 'submitting_order_state.dart';

class SubmittingOrderBloc
    extends Bloc<SubmittingOrderEvent, SubmittingOrderState> {
  SubmittingOrderBloc({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(SubmittingOrderState()) {
    _streamSubscription = _userRepository.addressStream.listen((action) {
      if (action == AddressStreamAction.addressEmpty) {
        add(SubmittingOrderAddressOnChanged(null));
      }
    });
  }

  final UserRepository _userRepository;
  StreamSubscription<AddressStreamAction> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<SubmittingOrderState> mapEventToState(
    SubmittingOrderEvent event,
  ) async* {
    if (event is SubmittingOrderOnLoaded) {
      yield* _mapOrderOnLoadedToState(event);
    } else if (event is SubmittingOrderShippingOnChanged) {
      yield* _mapShippingOnChangedToState(event);
    } else if (event is SubmittingOrderRemarkOnChanged) {
      yield state.copyWith(remarks: event.value);
    } else if (event is SubmittingOrderAddressOnChanged) {
      yield* _mapAddressOnChangedToState(event);
    } else if (event is SubmittingOrderButtonOnSubmitted) {
      yield* _mapButtonOnSubmittedToState();
    }
  }

  Stream<SubmittingOrderState> _mapButtonOnSubmittedToState() async* {
    if (state.address == null) {
      yield* state.copyErrorWithReset(SubmittingOrderError.addressEmpty);
      return;
    }

    if (state.selectedShipping == null) {
      yield* state.copyErrorWithReset(SubmittingOrderError.shippingEmpty);
      return;
    }

    yield state.copyWith(formzStatus: FormzStatus.submissionInProgress);
    final String cartIds = state.items.map((e) => e.cartId).join(',');
    final orderId = await _userRepository.toOrder(
        cartIds, state.selectedShipping.shippingId, state.address.addrId);
    yield state.copyWith(
        formzStatus: FormzStatus.submissionSuccess, orderId: orderId);
  }

  Stream<SubmittingOrderState> _mapAddressOnChangedToState(
    SubmittingOrderAddressOnChanged event,
  ) async* {
    final Address checked = event.address;
    if (checked == null) {
      yield state.copyWithEmptyAddress();
    } else if (state.selectedShipping != null) {
      final int shippingFee =
          await _getShippingFee(state.items, checked, state.selectedShipping);
      final double orderAmount = state.productAmount + shippingFee;
      yield state.copyWith(
        address: checked,
        shippingFee: shippingFee,
        orderAmount: orderAmount,
      );
    }
  }

  Stream<SubmittingOrderState> _mapShippingOnChangedToState(
    SubmittingOrderShippingOnChanged event,
  ) async* {
    if (state.address == null) {
      yield* state.copyErrorWithReset(SubmittingOrderError.addressEmpty);
      return;
    }

    final checked = event.item;
    final address = state.address;

    try {
      final int shippingFee =
          await _getShippingFee(state.items, address, checked);
      final double orderAmount = state.productAmount + shippingFee;
      yield state.copyWith(
          selectedShipping: checked,
          orderAmount: orderAmount,
          shippingFee: shippingFee);
    } catch (e) {}
  }

  Stream<SubmittingOrderState> _mapOrderOnLoadedToState(
      SubmittingOrderOnLoaded event) async* {
    final List<ShoppingCartItem> items = event.items;
    yield state.copyWith(status: PageStatus.inProcess);
    try {
      final List<ShippingItem> shippingList =
          await _userRepository.shippingList();
      final List<Address> addresses = await _userRepository.addresses;
      Address address;
      if (addresses.isNotEmpty) {
        address =
            addresses.firstWhere((e) => e.isCheck == '1', orElse: () => null);
      }
      ShippingItem shippingItem;
      if (shippingList.isNotEmpty) {
        shippingItem = shippingList.first;
      }
      int shippingFee;
      if (address != null && shippingItem != null) {
        shippingFee = await _getShippingFee(items, address, shippingItem);
      }

      double productAmount = 0.0;
      double orderAmount = 0.0;
      items.forEach((e) {
        productAmount += (e.number * e.price);
      });
      if (shippingFee != null) {
        orderAmount = productAmount + shippingFee;
      }

      yield state.copyWith(
          status: PageStatus.success,
          items: items,
          shippingList: shippingList,
          address: address,
          selectedShipping: shippingItem,
          shippingFee: shippingFee,
          productAmount: productAmount,
          orderAmount: orderAmount);
    } catch (e) {
      yield state.copyWith(status: PageStatus.failure);
    }
  }

  Future<int> _getShippingFee(
      List<ShoppingCartItem> items, Address address, ShippingItem item) async {
    final int totalCount =
        items.map((e) => e.number).reduce((a, b) => a + b);
    return await _userRepository.getShippingFee(
        item.shippingId, address.addrId, totalCount);
  }
}
