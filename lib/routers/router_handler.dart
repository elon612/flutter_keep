import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keep/components/components.dart';

import 'application.dart';

final notFoundHandler = Handler(
  handlerFunc: (_, __) => const NotFoundPage(),
);

final mainHandler = Handler(
    handlerFunc: (_, __) => MainPage(
          key: Application.mainKey,
        ));

final noticeListHandler = Handler(
  handlerFunc: (_, __) => NoticeListPage(),
);

final noticeHandler = Handler(
    handlerFunc: (context, __) => NoticePage(
          id: context.settings.arguments,
        ));

final searchHandler = Handler(
  handlerFunc: (_, __) => SearchPage(),
);

final shoppingCartHandler = Handler(
  handlerFunc: (_, __) => Scaffold(
    body: ShoppingCartScreen(),
  ),
);

final productHandler = Handler(
  handlerFunc: (context, __) =>
      ProductPage(productId: context.settings.arguments),
);

final productListHandler = Handler(handlerFunc: (context, _) {
  final data = context.arguments as Map<String, String>;
  return ProductListPage(
    brandId: data['brandId'],
    categoryId: data['categoryId'],
  );
});

final addressListHandler = Handler(
  handlerFunc: (context, __) => AddressListPage(
    fromSubmitting: context.arguments,
  ),
);

final addressManageHandler = Handler(
  handlerFunc: (context, __) => AddressManagePage(
    address: context.arguments,
  ),
);

final submittingOrderHandler = Handler(
  handlerFunc: (context, __) => SubmittingOrderPage(
    items: context.arguments,
  ),
);

final orderListHandler = Handler(
  handlerFunc: (_, __) => OrderListPage(),
);

final orderDetailHandler = Handler(
  handlerFunc: (context, _) => OrderDetailPage(
    orderId: context.arguments,
  ),
);

final orderPaymentHandler = Handler(
  handlerFunc: (context, _) => OrderPaymentPage(
    orderId: context.arguments,
  ),
);

final loginHandler = Handler(
  handlerFunc: (_, __) => LoginPage(),
);

final registerHandler = Handler(
  handlerFunc: (_, __) => RegisterPage(),
);

final settingsHandler = Handler(
  handlerFunc: (_, __) => SettingsPage(),
);

final feedbackHandler = Handler(
  handlerFunc: (_, __) => FeedbackPage(),
);
