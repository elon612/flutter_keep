import 'package:flutter/material.dart';
import 'package:flutter_keep/components/order/blocs/blocs.dart';
import 'package:flutter_keep/components/order/views/views.dart';
import 'package:flutter_keep/components/product/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:formz/formz.dart';
import 'package:oktoast/oktoast.dart';

import 'package:flutter_keep/components/common/common.dart';

extension on SubmittingOrderError {
  String message(BuildContext context) {
    switch (this) {
      case SubmittingOrderError.addressEmpty:
        return '地址不能为空！';
      case SubmittingOrderError.shippingEmpty:
        return '请选择一种物流方式';
      default:
        return '';
    }
  }
}

class SubmittingOrderPage extends StatelessWidget {
  const SubmittingOrderPage({Key key, this.items}) : super(key: key);
  final List<ShoppingCartItem> items;

  @override
  Widget build(BuildContext context) {
    final sectionStyle =
        TextStyle(color: Color(0xffA6A7Ad), fontSize: 14, height: 1.428);

    final borderRadius = BorderRadius.circular(15.0);
    final contentPadding = EdgeInsets.symmetric(horizontal: 10);
    final decoration =
        BoxDecoration(color: Colors.white, borderRadius: borderRadius);

    return BlocProvider<SubmittingOrderBloc>(
      create: (context) => SubmittingOrderBloc(
        userRepository: context.read<UserRepository>(),
      )..add(SubmittingOrderOnLoaded(items)),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('提交订单'),
          elevation: 4,
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer<SubmittingOrderBloc, SubmittingOrderState>(
          listener: (context, state) {
            if (state.error != SubmittingOrderError.noError) {
              showToast(state.error.message(context));
            } else if (state.formzStatus.isSubmissionSuccess) {
              RouterUtil.toOrderPayment(context, state.orderId);
            }
          },
          builder: (context, state) =>
              state.status.when(context, builder: (context) {
            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    color: Colours.greyBackground,
                    padding: contentPadding,
                    child: Column(
                      children: [
                        Gaps.vGap20,
                        OrderAddressView(
                          address: state.address,
                          onTap: () => _toAddressList(context),
                        ),
                        Gaps.vGap16,
                        _OrderProductPart(
                          items: state.items,
                          checked: state.selectedShipping,
                          shippingList: state.shippingList,
                          sectionStyle: sectionStyle,
                        ),
                        Gaps.vGap16,
                        Container(
                          padding: contentPadding.copyWith(top: 16, bottom: 14),
                          decoration: decoration,
                          child: Column(
                            children: [
                              _ConfirmSectionWidget(
                                left: Text(
                                  '商品金额',
                                  style: sectionStyle,
                                ),
                                rightText: '¥${state.productAmount}',
                              ),
                              Gaps.vGap16,
                              _ConfirmSectionWidget(
                                left: Text(
                                  '物流费用',
                                  // result.feeName,
                                  style: sectionStyle,
                                ),
                                rightText: '+ ¥${state.shippingFee}',
                              ),
                              Gaps.vGap16,
                              _OrderNotesWidget(
                                titleStyle: sectionStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                _SubmittingBottomBar(
                  orderAmount: state.orderAmount.toString(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _toAddressList(BuildContext context) async {
    final result = await RouterUtil.toAddressList(context, true);
    if (result != null) {
      context
          .read<SubmittingOrderBloc>()
          .add(SubmittingOrderAddressOnChanged(result));
    }
  }
}

class _SubmittingBottomBar extends StatelessWidget {
  const _SubmittingBottomBar({Key key, this.orderAmount}) : super(key: key);
  final String orderAmount;

  @override
  Widget build(BuildContext context) {
    final totalStyle = TextStyles.text;
    final priceStyle = totalStyle.copyWith(fontWeight: FontWeight.bold);
    return Container(
      color: Colors.white,
      height: 92,
      padding: const EdgeInsets.only(top: 8, bottom: 52),
      child: Row(
        children: [
          Spacer(),
          Text(
            '合计:',
            style: totalStyle,
          ),
          Text(
            '¥ $orderAmount',
            style: priceStyle,
          ),
          Gaps.hGap12,
          _SubmittedButton(),
          SizedBox(
            width: 18,
          ),
        ],
      ),
    );
  }
}

class _SubmittedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmittingOrderBloc, SubmittingOrderState>(
      builder: (context, state) =>
          state.formzStatus == FormzStatus.submissionInProgress
              ? CircularProgressIndicator()
              : Container(
                  width: 88,
                  height: 33,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xff4d4d4d),
                      Color(0xff3c3c3c),
                    ]),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      '提交订单',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () => context
                        .read<SubmittingOrderBloc>()
                        .add(SubmittingOrderButtonOnSubmitted()),
                  ),
                ),
    );
  }
}

class _OrderProductPart extends StatelessWidget {
  const _OrderProductPart(
      {Key key, this.items, this.shippingList, this.checked, this.sectionStyle})
      : super(key: key);
  final List<ShoppingCartItem> items;
  final List<ShippingItem> shippingList;
  final ShippingItem checked;
  final TextStyle sectionStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 24, top: 20, bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          OrderProductView(
            carts: items,
          ),
          SizedBox(
            height: 24,
          ),
          _ConfirmSectionWidget(
            left: Text(
              '配送方式',
              style: sectionStyle,
            ),
            rightText: checked.shippingName,
            onTap: () => _showShippingDialog(context, checked, shippingList),
            hasTailArrow: true,
          ),
        ],
      ),
    );
  }

  void _showShippingDialog(BuildContext context, ShippingItem checked,
      List<ShippingItem> list) async {
    ShippingItem toChecked = checked;
    final actionStyle = TextStyles.text14;

    final result = await showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
                buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colours.text,
              focusColor: Colours.text,
              hoverColor: Colours.text,
            )),
            child: StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Text(
                  '配送方式',
                  style: TextStyles.title,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                actionsOverflowButtonSpacing: 20,
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        '取消',
                        style: actionStyle,
                      )),
                  TextButton(
                      onPressed: () => Navigator.pop(context, toChecked),
                      child: Text(
                        '确认',
                        style: actionStyle,
                      )),
                ],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: list
                      .map((e) => ListTile(
                            leading: Radio<bool>(
                              fillColor:
                                  MaterialStateProperty.all(Colours.text),
                              value: toChecked == e,
                              groupValue: true,
                              onChanged: (v) {
                                setState(() {
                                  toChecked = e;
                                });
                              },
                            ),
                            title: Text(e.shippingName),
                          ))
                      .toList(),
                ),
              ),
            ),
          );
        });

    if (result != null) {
      context
          .read<SubmittingOrderBloc>()
          .add(SubmittingOrderShippingOnChanged(result));
    }
  }
}

class _OrderNotesWidget extends StatefulWidget {
  const _OrderNotesWidget({Key key, this.titleStyle}) : super(key: key);
  final TextStyle titleStyle;

  @override
  __OrderNotesWidgetState createState() => __OrderNotesWidgetState();
}

class __OrderNotesWidgetState extends State<_OrderNotesWidget> {
  FocusNode _node;

  @override
  void initState() {
    _node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget textField = Expanded(
      child: TextField(
        focusNode: _node,
        style: TextStyle(fontSize: 12.0),
        textDirection: TextDirection.rtl,
        onChanged: (v) => (v),
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            hintText: '请输入订单备注（可不填）',
            border: InputBorder.none,
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle()),
      ),
    );

    return Row(
      children: [
        Text('订单备注', style: widget.titleStyle),
        Gaps.hGap10,
        textField,
      ],
    );
  }
}

class _ConfirmSectionWidget extends StatelessWidget {
  const _ConfirmSectionWidget(
      {Key key,
      this.leftText,
      this.rightText,
      this.hasTailArrow = false,
      this.onTap,
      this.left})
      : super(key: key);

  final Widget left;
  final String leftText;
  final String rightText;
  final bool hasTailArrow;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final rightStyle = TextStyles.text.copyWith(fontSize: 14);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          left ??
              Text(
                leftText,
              ),
          Spacer(),
          Text(
            rightText,
            style: rightStyle,
          ),
          if (hasTailArrow) ...[
            Gaps.hGap16,
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 14,
              color: Color(0xffb3b3b3),
            )
          ],
        ],
      ),
    );
  }
}
