part of 'submitting_order_bloc.dart';

enum SubmittingOrderError { noError, addressEmpty, shippingEmpty }

class SubmittingOrderState extends Equatable {
  const SubmittingOrderState(
      {this.status = PageStatus.init,
      this.orderId,
      this.items = const [],
      this.productAmount,
      this.shippingFee,
      this.orderAmount,
      this.selectedShipping,
      this.shippingList,
      this.address,
      this.remarks = '',
      this.formzStatus = FormzStatus.pure,
      this.error = SubmittingOrderError.noError});

  final String orderId;

  final PageStatus status;

  final List<ShoppingCartItem> items;

  final double productAmount;

  final int shippingFee;

  final double orderAmount;

  final ShippingItem selectedShipping;

  final List<ShippingItem> shippingList;

  final Address address;

  final String remarks;

  final FormzStatus formzStatus;

  final SubmittingOrderError error;

  Stream<SubmittingOrderState> copyErrorWithReset(
      SubmittingOrderError error) async* {
    yield this.copyWith(error: error);
    yield this.copyWith(error: SubmittingOrderError.noError);
  }

  SubmittingOrderState copyWithEmptyAddress() => SubmittingOrderState(
        orderId: this.orderId,
        status: this.status,
        items: this.items,
        productAmount: this.productAmount,
        shippingFee: this.shippingFee,
        orderAmount: this.orderAmount,
        selectedShipping: this.selectedShipping,
        shippingList: this.shippingList,
        remarks: this.remarks,
        formzStatus: this.formzStatus,
        error: this.error,
      );

  SubmittingOrderState copyWith(
          {PageStatus status,
          String orderId,
          List<ShoppingCartItem> items,
          double productAmount,
          int shippingFee,
          double orderAmount,
          ShippingItem selectedShipping,
          List<ShippingItem> shippingList,
          Address address,
          String remarks,
          FormzStatus formzStatus,
          SubmittingOrderError error}) =>
      SubmittingOrderState(
          status: status ?? this.status,
          orderId: orderId ?? this.orderId,
          items: items ?? this.items,
          productAmount: productAmount ?? this.productAmount,
          shippingFee: shippingFee ?? this.shippingFee,
          orderAmount: orderAmount ?? this.orderAmount,
          selectedShipping: selectedShipping ?? this.selectedShipping,
          shippingList: shippingList ?? this.shippingList,
          address: address ?? this.address,
          remarks: remarks ?? this.remarks,
          formzStatus: formzStatus ?? this.formzStatus,
          error: error ?? this.error);

  @override
  List<Object> get props => [
        status,
        orderId,
        items,
        productAmount,
        shippingFee,
        orderAmount,
        selectedShipping,
        shippingList,
        address,
        remarks,
        formzStatus,
        error,
      ];
}
