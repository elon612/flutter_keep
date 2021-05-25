import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:formz/formz.dart';

part 'order_payment_state.dart';

enum PaymentType {
  alipay,
  balance,
}

class OrderPaymentCubit extends Cubit<OrderPaymentState> {
  OrderPaymentCubit({String orderId, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(OrderPaymentState(orderId: orderId));

  final UserRepository _userRepository;

  /// 支付方式切换
  void paymentOnChanged(PaymentType e) => emit(state.copyWith(type: e));

  /// 支付
  Future<void> onPay() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    await _userRepository.onPay(state.orderId);
    emit(state.copyWith(status: FormzStatus.submissionSuccess));
  }
}
