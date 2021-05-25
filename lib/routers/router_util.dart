import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/application.dart';
import 'router.dart' as RR;

class RouterUtil {
  static FluroRouter get router => Application.router;

  static Future _navigateTo(
    BuildContext context,
    String path, {
    bool clearStack = false,
    bool replace = false,
    TransitionType transition = TransitionType.native,
    RouteSettings routeSettings,
  }) {
    return router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: transition,
        routeSettings: routeSettings);
  }

  /// 到主页
  static Future toMain(BuildContext context, {bool clearStack = true}) {
    return _navigateTo(context, RR.Router.main,
        clearStack: clearStack, transition: TransitionType.fadeIn);
  }

  /// 到公告列表
  static Future toNoticeList(BuildContext context) =>
      _navigateTo(context, RR.Router.noticeList);

  /// 到公告
  static Future toNotice(BuildContext context, int id) => _navigateTo(
        context,
        RR.Router.notice,
        routeSettings: RouteSettings(arguments: id),
      );

  /// 到搜索
  static Future toSearch(BuildContext context) =>
      _navigateTo(context, RR.Router.search);

  static Future toShoppingCartPage(BuildContext context) =>
      _navigateTo(context, RR.Router.shoppingCart);

  /// 到商品列表
  /// [categoryId] 类目id
  /// [brandId] 品牌 id
  static Future toProductList(
          BuildContext context, String categoryId, String brandId) =>
      _navigateTo(
        context,
        RR.Router.productList,
        routeSettings: RouteSettings(arguments: <String, String>{
          'categoryId': categoryId,
          'brandId': brandId,
        }),
      );

  /// 到商品页面
  static Future toProduct(BuildContext context, String productId) =>
      _navigateTo(
        context,
        RR.Router.product,
        routeSettings: RouteSettings(arguments: productId),
      );

  /// 到地址列表
  static Future toAddressList(BuildContext context,
          [bool fromSubmitting = false]) =>
      hasAuthenticated(
        context,
        executable: (context) => _navigateTo(
          context,
          RR.Router.addressList,
          routeSettings: RouteSettings(arguments: fromSubmitting),
        ),
      );

  /// 到地址管理页面
  static Future toAddressManage(BuildContext context, Address address) =>
      _navigateTo(
        context,
        RR.Router.addressManage,
        routeSettings: RouteSettings(arguments: address),
      );

  /// 到提交订单页
  static Future toSubmitting(
          BuildContext context, List<ShoppingCartItem> items) =>
      _navigateTo(
        context,
        RR.Router.submittingOrder,
        routeSettings: RouteSettings(arguments: items),
      );

  /// 到订单列表页
  static Future toOrderList(BuildContext context) => hasAuthenticated(
        context,
        executable: (context) => _navigateTo(context, RR.Router.orderList),
      );

  /// 到订单详情页
  static Future toOrderDetail(BuildContext context, String orderId,
          {bool replace = false}) =>
      _navigateTo(context, RR.Router.orderDetail,
          routeSettings: RouteSettings(arguments: orderId), replace: replace);

  /// 到订单支付页面
  /// [orderId] 订单id
  static Future toOrderPayment(BuildContext context, String orderId) =>
      _navigateTo(context, RR.Router.orderPayment,
          routeSettings: RouteSettings(arguments: orderId), replace: true);

  /// 到登陆页面
  static Future toLogin(BuildContext context) =>
      _navigateTo(context, RR.Router.login);

  /// 到注册页面
  static Future toRegister(BuildContext context) =>
      _navigateTo(context, RR.Router.register);

  /// 到设置页面
  static Future toSettings(BuildContext context) =>
      _navigateTo(context, RR.Router.settings);

  /// 到问题反馈页面
  static Future toFeedback(BuildContext context) => hasAuthenticated(
        context,
        executable: (context) => _navigateTo(context, RR.Router.feedback),
      );

  /// 验证登陆
  static hasAuthenticated(BuildContext context,
      {Future Function(BuildContext context) executable}) {
    final AuthenticationBloc bloc = context.read<AuthenticationBloc>();
    if (bloc.state.status == AuthenticationStatus.authenticated) {
      if (executable != null) return executable(context);
    } else {
      toLogin(context);
    }
  }
}
