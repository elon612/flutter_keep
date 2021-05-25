part of 'order_payment_cubit.dart';

class OrderPaymentState extends Equatable {
  const OrderPaymentState(
      {this.orderId,
      this.status = FormzStatus.pure,
      this.type = PaymentType.balance});

  final String orderId;

  final FormzStatus status;

  final PaymentType type;

  OrderPaymentState copyWith(
          {String orderId, FormzStatus status, PaymentType type}) =>
      OrderPaymentState(
          orderId: orderId ?? this.orderId,
          status: status ?? this.status,
          type: type ?? this.type);

  @override
  List<Object> get props => [orderId, status, type];
}
