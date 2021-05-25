import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/order/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:formz/formz.dart';

extension on PaymentType {
  String message(BuildContext context) {
    switch (this) {
      case PaymentType.alipay:
        return '支付宝支付';
      case PaymentType.balance:
        return '余额支付';
    }
    return null;
  }

  ImageProvider get image {
    switch (this) {
      case PaymentType.alipay:
        return R.assets.paymentAlipay;
      case PaymentType.balance:
        return R.assets.paymentBalance;
        break;
    }
    return null;
  }
}

class OrderPaymentPage extends StatelessWidget {
  const OrderPaymentPage({Key key, this.orderId}) : super(key: key);
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderPaymentCubit>(
      create: (context) => OrderPaymentCubit(
        orderId: orderId,
        userRepository: context.read<UserRepository>(),
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('订单支付'),
          elevation: 4,
          backgroundColor: Colors.white,
        ),
        body: BlocListener<OrderPaymentCubit, OrderPaymentState>(
          listener: (context, state) {
            if (state.status == FormzStatus.submissionSuccess) {
              RouterUtil.toOrderDetail(context, state.orderId, replace: true);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                _ContentView(),
                _PayButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderPaymentCubit, OrderPaymentState>(
      builder: (context, state) => state.status ==
              FormzStatus.submissionInProgress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: TextButton(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 48)),
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      )),
                  onPressed: () => context.read<OrderPaymentCubit>().onPay(),
                  child: Text(
                    '确认支付',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget divider = Divider(
      height: 1,
    );
    return BlocBuilder<OrderPaymentCubit, OrderPaymentState>(
        builder: (context, state) => Column(
              children: [
                Gaps.vGap20,
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text('选择支付方式'),
                  ),
                ),
                divider,
                Column(
                  children: PaymentType.values
                      .map((e) => InkWell(
                            onTap: () => context
                                .read<OrderPaymentCubit>()
                                .paymentOnChanged(e),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Gaps.hGap10,
                                      Image(
                                        image: e.image,
                                        width: 26,
                                      ),
                                      Gaps.hGap8,
                                      Text(
                                        e.message(context),
                                        style: TextStyles.text14,
                                      ),
                                      Spacer(),
                                      Checkbox(
                                          activeColor: Colours.text,
                                          value: state.type == e,
                                          onChanged: (v) => {}),
                                    ],
                                  ),
                                ),
                                divider,
                              ],
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ));
  }
}
