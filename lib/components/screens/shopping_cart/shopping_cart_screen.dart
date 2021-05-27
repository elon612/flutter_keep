import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/components/screens/shopping_cart/formz/formz.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/router_util.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:formz/formz.dart';
import 'package:oktoast/oktoast.dart';

import 'package:flutter_keep/components/common/common.dart';

import 'blocs/blocs.dart';

extension on ShoppingCartInputError {
  String text(BuildContext context) {
    switch (this) {
      case ShoppingCartInputError.empty:
        return '您还没有选择商品';
    }
    return '';
  }
}

extension on ShoppingCartError {
  String text(BuildContext context) {
    switch (this) {
      case ShoppingCartError.limitExceeded:
        return '库存不足';
      default:
        return '';
    }
  }
}

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with AutomaticKeepAliveClientMixin {
  void _preCacheImages() {
    [
      R.assets.cartCheck,
      R.assets.cartCheckActive,
    ].map((e) => precacheImage(e, context)).toList();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preCacheImages();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return BlocProvider(
            create: (_) => ShoppingCartBloc(
              repository: context.read<UserRepository>(),
            )..add(ShoppingCartOnLoaded()),
            child: BlocConsumer<ShoppingCartBloc, ShoppingCartState>(
              listener: (context, state) {
                if (state.error != ShoppingCartError.noError) {
                  showToast(state.error.text(context));
                }
              },
              builder: (context, state) => state.status.when(
                context,
                builder: (context) => state.items.isEmpty
                    ? CustomStateWidget(
                        type: StateType.cart,
                        actionText: '去首页',
                        actionOnTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          } else {
                            Application.mainKey.currentState.jumpToZero();
                          }
                        },
                      )
                    : _ShoppingCartContentView(
                        items: state.items,
                        selected: state.selected,
                      ),
              ),
            ),
          );
        }
        return CustomStateWidget(
          type: StateType.cartUnauthenticated,
          actionText: '去登陆',
          actionOnTap: () => RouterUtil.toLogin(context),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ShoppingCartContentView extends StatelessWidget {
  const _ShoppingCartContentView({Key key, this.items, this.selected})
      : super(key: key);

  final List<ShoppingCartItem> items;

  final List<ShoppingCartItem> selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.greyBackground,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    '购物车',
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.428,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: () async => context
                      .read<ShoppingCartBloc>()
                      .add(ShoppingCartOnRefresh()),
                ),
                SliverPadding(padding: const EdgeInsets.only(top: 24)),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = items[index];
                    final findIndex = selected.indexOf(item);
                    final last = index == (items.length - 1);
                    return _ShoppingCartItemView(
                      item: items[index],
                      checked: findIndex != -1,
                      last: last,
                    );
                  }, childCount: items.length),
                ),
                SliverPadding(padding: const EdgeInsets.only(top: 48)),
              ],
            ),
          ),
          _BottomBar(),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalStyle = TextStyle(fontSize: 12, color: Colors.black);
    final unitStyle = totalStyle.copyWith(color: Colours.text);
    final priceStyle = TextStyles.text.copyWith(fontWeight: FontWeight.bold);

    return SafeArea(
      child: Container(
        height: 49,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
            vertical: BorderSide(
              width: 0.2,
              color: Colours.greyBackground,
            ),
          ),
        ),
        child: BlocConsumer<ShoppingCartBloc, ShoppingCartState>(
          listener: (context, state) {
            if (state.input.invalid) {
              showToast(state.input.error.text(context));
            } else if (state.formzStatus == FormzStatus.submissionSuccess) {
              RouterUtil.toSubmitting(context, state.selected);
            }
          },
          builder: (context, state) {
            String total;
            if (state.selected.isEmpty) {
              total = '0';
            } else {
              double num = 0.0;
              state.selected.forEach((e) {
                num += (e.number * e.price);
              });
              total = num.toString();
            }

            return Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context
                      .read<ShoppingCartBloc>()
                      .add(ShoppingCartAllCheckOnToggled()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      state.allChecked
                          ? R.assets.cartCheckActive.image()
                          : R.assets.cartCheck.image(),
                      Gaps.hGap8,
                      Text(
                        '全选',
                        style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 16,
                            height: 1.375),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text.rich(TextSpan(text: '合计：', style: totalStyle, children: [
                  TextSpan(text: '¥ ', style: unitStyle),
                  TextSpan(text: total, style: priceStyle),
                ])),
                Gaps.hGap8,
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xff4d4d4d),
                          Color(0xff3c3c3c),
                        ]),
                      ),
                      child: TextButton(
                        style: defaultButtonStyle,
                        onPressed: () => context
                            .read<ShoppingCartBloc>()
                            .add(ShoppingCartOnSubmitted()),
                        child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                          builder: (context, state) {
                            int totalNumbers = 0;
                            try {
                              totalNumbers = state.selected
                                  .map((e) => e.number)
                                  .reduce((a, b) => a + b);
                            } catch (_) {}
                            return Text(
                              '结算' +
                                  "${totalNumbers == 0 ? '' : '($totalNumbers)'}",
                              style:
                                  TextStyles.text.copyWith(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ShoppingCartItemView extends StatelessWidget {
  const _ShoppingCartItemView({Key key, this.checked, this.item, this.last})
      : super(key: key);

  final bool last;

  final bool checked;

  final ShoppingCartItem item;

  @override
  Widget build(BuildContext context) {
    final skuStyle =
        TextStyles.text12.copyWith(height: 1.4, color: Colours.textGrey2);
    final priceStyle =
        TextStyles.title.copyWith(height: 1.4, fontWeight: FontWeight.bold);
    final unitStyle =
        priceStyle.copyWith(fontSize: 13, fontWeight: FontWeight.w400);

    final check = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        child: checked
            ? R.assets.cartCheckActive.image()
            : R.assets.cartCheck.image(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      onTap: () => context
          .read<ShoppingCartBloc>()
          .add(ShoppingCartItemCheckOnToggled(item)),
    );

    final image = GestureDetector(
      onTap: () => RouterUtil.toProduct(context, item.prdId),
      child: SizedBox.fromSize(
        size: const Size.square(100),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: FadeInImage(
              image: AssetImage(item.pic),
              fit: BoxFit.cover,
              placeholder: R.assets.imagePlaceholder,
            )),
      ),
    );

    final rightHeader = Row(
      children: [
        Expanded(
          child: Text(
            item.productName,
            style: TextStyles.text.copyWith(
              height: 1.375,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
          ),
        ),
        SizedBox.fromSize(
          size: Size.square(20),
          child: FittedBox(
            child: CloseButton(
              color: Colors.black,
              onPressed: () => context
                  .read<ShoppingCartBloc>()
                  .add(ShoppingCartItemOnDeleted(item)),
            ),
          ),
        )
      ],
    );

    final sku = Text(
      item.propValue,
      style: skuStyle,
    );

    final rightBottom = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: Text.rich(
          TextSpan(text: '¥', style: unitStyle, children: [
            TextSpan(
              text: ' ${item.price}',
              style: priceStyle,
            )
          ]),
          maxLines: 1,
          overflow: TextOverflow.clip,
        )),
        CounterWidget(
          value: item.number.toString(),
          minusOnTap: () => context
              .read<ShoppingCartBloc>()
              .add(ShoppingCartItemMinusNumberOnPressed(item)),
          plusOnTap: () => context
              .read<ShoppingCartBloc>()
              .add(ShoppingCartItemPlusNumberOnPressed(item)),
        ),
      ],
    );

    final right = Expanded(
      child: Container(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rightHeader,
              Gaps.hGap4,
              sku,
              Spacer(),
              rightBottom,
            ],
          ),
        ),
      ),
    );

    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  check,
                  image,
                  right,
                ],
              ),
            ),
            if (!last) Divider(),
          ],
        ));
  }
}
