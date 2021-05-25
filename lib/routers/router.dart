import 'package:fluro/fluro.dart';
import 'package:flutter_keep/routers/router_handler.dart';

class Router {
  static String root = '/';
  static String main = '/main';
  static String login = '/login';
  static String register = '/register';
  static String notice = '/notice';
  static String search = '/search';
  static String product = '/product';
  static String shoppingCart = '/shoppingCart';
  static String productList = '/productList';
  static String noticeList = '/noticeList';
  static String addressList = '/addressList';
  static String addressManage = '/addressManage';
  static String submittingOrder = '/submittingOrder';
  static String orderList = '/orderList';
  static String orderDetail = '/orderDetail';
  static String orderPayment = '/orderPayment';
  static String settings = '/settings';
  static String feedback = '/feedback';

  static void configureRouter(FluroRouter router) {
    router.notFoundHandler = notFoundHandler;
    router.define(main, handler: mainHandler);
    router.define(login, handler: loginHandler);
    router.define(register, handler: registerHandler);
    router.define(notice, handler: noticeHandler);
    router.define(search, handler: searchHandler);
    router.define(shoppingCart, handler: shoppingCartHandler);
    router.define(product, handler: productHandler);
    router.define(productList, handler: productListHandler);
    router.define(noticeList, handler: noticeListHandler);
    router.define(addressList, handler: addressListHandler);
    router.define(addressManage, handler: addressManageHandler);
    router.define(submittingOrder, handler: submittingOrderHandler);
    router.define(orderList, handler: orderListHandler);
    router.define(orderDetail, handler: orderDetailHandler);
    router.define(orderPayment, handler: orderPaymentHandler);
    router.define(settings, handler: settingsHandler);
    router.define(feedback, handler: feedbackHandler);
  }
}
