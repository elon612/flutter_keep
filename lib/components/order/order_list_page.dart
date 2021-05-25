import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/order/widgets/widgets.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_keep/components/common/common.dart';
import 'blocs/blocs.dart';
import 'views/views.dart';

extension on OrderType {
  String text(BuildContext context) {
    switch (this) {
      case OrderType.all:
        return '全部';
      case OrderType.unPay:
        return '待付款';
      case OrderType.completed:
        return '已完成';
      case OrderType.canceled:
        return '已取消';
    }
    return '';
  }
}

class OrderListPage extends StatelessWidget {
  const OrderListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('订单列表'),
        backgroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: OrderType.values.length,
        child: Column(
          children: [
            _CustomTabBar(),
            Expanded(
              child: TabBarView(
                children: OrderType.values
                    .map((e) => _CustomTabBarView(
                          type: e,
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CustomTabBarView extends StatefulWidget {
  const _CustomTabBarView({Key key, this.type}) : super(key: key);
  final OrderType type;

  @override
  __CustomTabBarViewState createState() => __CustomTabBarViewState();
}

class __CustomTabBarViewState extends State<_CustomTabBarView>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller;

  @override
  void initState() {
    _controller = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => OrderListBloc(
          userRepository: context.read<UserRepository>(),
          refreshController: _controller)
        ..add(OrderListOnLoaded(widget.type)),
      child: BlocBuilder<OrderListBloc, OrderListState>(
        builder: (context, state) => state.status.when(context,
            builder: (context) => _OrderListView(
                  items: state.items,
                  controller: _controller,
                )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _OrderListView extends StatelessWidget {
  const _OrderListView({Key key, this.items, this.controller})
      : super(key: key);
  final List<OrderItem> items;
  final RefreshController controller;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SafeArea(
        child: CustomStateWidget(
          type: StateType.order,
        ),
      );
    }

    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      onLoading: () => context.read<OrderListBloc>().add(OrderListOnPulled()),
      controller: controller,
      child: ListView.builder(
        key: const Key('order_list_view'),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => RouterUtil.toOrderDetail(context, item.orderId),
            child: _OrderItemView(
              item: item,
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}

class _OrderItemView extends StatelessWidget {
  const _OrderItemView({Key key, this.item}) : super(key: key);
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final headStyle = TextStyles.text;

    final topPadding = 12.0;
    final imagePadding = topPadding * 2;
    final paddingBox = SizedBox(
      height: topPadding,
    );
    final SizedBox box = SizedBox(
      height: imagePadding,
    );

    Widget header = Row(
      children: [
        Text(
          '订单号：${item.orderSn}',
          style: headStyle,
        ),
        Spacer(),
        Text(
          item.orderStatusText,
          style: headStyle,
        ),
      ],
    );

    final divider = Divider(
      height: 1,
      color: Color(0xfff2f2f2),
    );

    final bottom = item.orderStatus == '0'
        ? Column(
            children: [
              divider,
              Gaps.vGap20,
              _OrderListOptionBar(
                item: item,
              ),
              Gaps.vGap20,
            ],
          )
        : Gaps.empty;

    Widget content = Column(
      children: [
        paddingBox,
        header,
        paddingBox,
        divider,
        box,
        IgnorePointer(
          child: OrderProductView(
            carts: item.items,
          ),
        ),
        box,
        bottom,
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(top: topPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: content,
    );
  }
}

class _OrderListOptionBar extends StatelessWidget {
  const _OrderListOptionBar({Key key, this.item}) : super(key: key);
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OrderButton(
          key: Key('order_list_cancel'),
          text: '取消订单',
          color: Color(0xffb2b2b2),
          onPressed: () =>
              context.read<OrderListBloc>().add(OrderListOnCanceled(item)),
        ),
        Gaps.hGap12,
        OrderButton(
          key: Key('order_list_pay'),
          text: '立即付款',
          color: Colours.text,
          onPressed: () => RouterUtil.toOrderPayment(context, item.orderId),
        ),
      ],
    );
  }
}

class _CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final color = Colours.text;
    final unSelectedColor = Colours.textGrey2;

    final labelStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.0),
          )),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: color,
        labelStyle: labelStyle,
        labelColor: color,
        unselectedLabelColor: unSelectedColor,
        tabs: OrderType.values
            .map(
              (e) => Tab(
                text: e.text(context),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48.5);
}
