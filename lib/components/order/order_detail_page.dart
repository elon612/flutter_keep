import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/order/views/views.dart';
import 'package:flutter_keep/components/order/widgets/widgets.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

import 'package:flutter_keep/components/common/common.dart';
import 'blocs/blocs.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({Key key, this.orderId}) : super(key: key);
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailBloc>(
        create: (context) => OrderDetailBloc(
              userRepository: context.read<UserRepository>(),
            )..add(OrderDetailOnLoaded(orderId)),
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text('订单详情'),
            elevation: 4,
            backgroundColor: Colors.white,
          ),
          body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
            builder: (context, state) => state.status.when(context,
                builder: (context) => _OrderDetailContentView(
                      orderItem: state.item,
                    )),
          ),
        ));
  }
}

class _OrderDetailContentView extends StatelessWidget {
  const _OrderDetailContentView({Key key, this.orderItem}) : super(key: key);
  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    final TextStyle addressStyle = TextStyles.text;
    final TextStyle headStyle =
        addressStyle.copyWith(fontSize: 12, color: Colours.textGrey);
    final TextStyle contentStyle =
        addressStyle.copyWith(color: Color(0xff333333), fontSize: 14);
    final BorderRadius borderRadius = BorderRadius.circular(12);

    final divider = Divider(
      height: 1,
      color: Colours.greyBackground,
    );

    Widget statusBar = Container(
      decoration: BoxDecoration(
        color: Colours.text,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      alignment: Alignment.center,
      child: Text(
        orderItem.orderStatusText,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Color(0xffffffff),
        ),
      ),
      height: 48,
    );
    Widget address = OrderAddressView(
      address: orderItem.address,
    );

    Widget settlement = Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('订单结算', style: headStyle),
          Gaps.vGap8,
          DefaultTextStyle(
            style: contentStyle,
            child: Padding(
              padding: EdgeInsets.only(left: 1),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '商品价格',
                      ),
                      Spacer(),
                      Text(
                        '${orderItem.productAmount}',
                      ),
                    ],
                  ),
                  Gaps.vGap8,
                  Row(
                    children: [
                      Text(
                        '配送运费',
                      ),
                      Spacer(),
                      Text(
                        '${orderItem.shippingFee}',
                      ),
                    ],
                  ),
                  Gaps.vGap8,
                  Row(
                    children: [
                      Text(
                        '积分抵扣',
                      ),
                      Spacer(),
                      Text(
                        '0',
                      ),
                    ],
                  ),
                  Gaps.vGap8,
                  Row(
                    children: [
                      Text(
                        '订单总价',
                      ),
                      Spacer(),
                      Text(
                        '${orderItem.orderAmount}',
                      ),
                    ],
                  ),
                  Gaps.vGap8,
                  Row(
                    children: [
                      Text(
                        '支付方式',
                      ),
                      Spacer(),
                      Text(
                        '支付宝/余额',
                      ),
                    ],
                  ),
                  Gaps.vGap16,
                ],
              ),
            ),
          )
        ],
      ),
    );

    Widget productInfo = Padding(
      padding: EdgeInsets.only(left: 19, right: 19, top: 21),
      child: OrderProductView(
        carts: orderItem.items,
      ),
    );

    Widget orderInfo = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('订单信息', style: headStyle),
          Gaps.vGap8,
          DefaultTextStyle(
            style: contentStyle,
            child: Padding(
              padding: EdgeInsets.only(left: 1),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('订单金额'),
                      Spacer(),
                      Text(orderItem.orderAmount),
                    ],
                  ),
                  Gaps.vGap8,
                  Row(
                    children: [
                      Text('订单编号'),
                      Spacer(),
                      Text(orderItem.orderSn),
                    ],
                  ),
                  Gaps.vGap8,
                  Row(
                    children: [
                      Text('下单时间'),
                      Spacer(),
                      Text(_getTime(orderItem.addTime)),
                    ],
                  ),
                  Gaps.vGap8,
                  Row(
                    children: [
                      Text('付款时间'),
                      Spacer(),
                      Text(_getTime('0')),
                    ],
                  ),
                  SizedBox(
                    height: 38,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget detailInfo = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: Column(
        children: [
          productInfo,
          Gaps.vGap20,
          divider,
          Gaps.vGap16,
          settlement,
          divider,
          Gaps.vGap16,
          orderInfo
        ],
      ),
    );

    Widget listView = Expanded(
      child: ListView(
        children: [
          statusBar,
          Gaps.vGap12,
          address,
          Gaps.vGap10,
          detailInfo,
          SizedBox(
            height: 38,
          ),
        ],
      ),
    );

    return Container(
      child: Column(
        children: [
          listView,
          orderItem.orderStatus == '0'
              ? _BottomBar(
                  item: orderItem,
                )
              : Gaps.empty,
        ],
      ),
    );
  }

  String _getTime(String time) {
    final parsedTime = int.tryParse(time);
    if (parsedTime == null || parsedTime == 0) return '';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(parsedTime * 1000);
    return formatDate(
        dateTime, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({Key key, this.item}) : super(key: key);
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OrderButton(
            text: '取消订单',
            color: Color(0xffb2b2b2),
            onPressed: () => {},
          ),
          Gaps.hGap12,
          OrderButton(
            text: '\u3000付款\u3000',
            color: Colours.text,
            onPressed: () => RouterUtil.toOrderPayment(context, item.orderId),
          ),
          Gaps.hGap20,
        ],
      ),
    );
  }
}
