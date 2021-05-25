import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:oktoast/oktoast.dart';

import 'blocs/blocs.dart';

extension on ShoppingCartSheetError {
  String message(BuildContext context) {
    switch (this) {
      case ShoppingCartSheetError.unauthenticated:
        return '请先登录！';
      case ShoppingCartSheetError.empty:
        return '请先选择 sku 属性';
      case ShoppingCartSheetError.invalid:
        return '数量无效';
      default:
        return '';
    }
  }
}

class ShoppingCartBottomSheet extends StatelessWidget {
  const ShoppingCartBottomSheet({Key key, this.skuItems, this.skus, this.info})
      : super(key: key);

  final List<Sku> skus;
  final ProductDetailInfo info;
  final List<SkuItems> skuItems;

  static showBottomSheet(BuildContext context, List<Sku> skus,
      List<SkuItems> skuItems, ProductDetailInfo info) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) => ShoppingCartBottomSheet(
              skus: skus,
              skuItems: skuItems,
              info: info,
            ),
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyles.text;
    final TextStyle boldStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
    final TextStyle unitStyle = textStyle.copyWith(fontSize: 12, height: 1.416);
    final TextStyle priceStyle = textStyle.copyWith(
        fontWeight: FontWeight.bold, fontSize: 28, height: 1.428);

    Widget basic = Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            child: SizedBox.fromSize(
              size: Size.square(64),
              child: FadeInImage(
                placeholder: R.assets.imagePlaceholder,
                image: R.json.images.productImage1,
                fit: BoxFit.cover,
              ),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          Gaps.hGap20,
          BlocBuilder<ShoppingCartSheetBloc, ShoppingCartSheetState>(
            builder: (context, state) {
              return Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    '¥',
                    style: unitStyle,
                  ),
                  Gaps.hGap4,
                  Text(
                    state.selectedSku != null ? state.selectedSku.price : '69',
                    style: priceStyle,
                  ),
                ],
              );
            },
          )
        ],
      ),
    );

    Widget shipping = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '配送区域',
          style: boldStyle,
        ),
        Gaps.vGap4,
        Text('苏州 工业园区 xx 街道',
            style: TextStyles.text.copyWith(fontWeight: FontWeight.w300)),
      ],
    );

    Widget counter = BlocBuilder<ShoppingCartSheetBloc, ShoppingCartSheetState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('购买数量 ', style: boldStyle),
            state.selectedSku != null
                ? Text(
                    '库存${state.selectedSku.stock}件',
                    style: TextStyles.text12.copyWith(
                      color: Colours.textGrey2,
                    ),
                  )
                : Gaps.empty,
            Spacer(),
            CounterWidget(
              value: state.number.toString(),
              minusOnTap: () => context
                  .read<ShoppingCartSheetBloc>()
                  .add(ShoppingCartSheetNumberMinusOnClicked()),
              plusOnTap: () => context
                  .read<ShoppingCartSheetBloc>()
                  .add(ShoppingCartSheetNumberPlusOnClicked()),
            ),
          ],
        );
      },
    );

    Widget button = BlocBuilder<ShoppingCartSheetBloc, ShoppingCartSheetState>(
      builder: (context, state) {
        return state.snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TextButton(
                onPressed: () => context
                    .read<ShoppingCartSheetBloc>()
                    .add(ShoppingCartSheetButtonOnClicked()),
                child: Text(
                  '加入购物车',
                  style: boldStyle.copyWith(color: Colors.white),
                ),
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all(Size(double.maxFinite, 35)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0))),
                  backgroundColor: MaterialStateProperty.all(Colours.text),
                ),
              );
      },
    );

    return BlocProvider(
      create: (_) => ShoppingCartSheetBloc(
        repository: context.read<UserRepository>(),
        bloc: context.read<AuthenticationBloc>(),
      )..add(ShoppingCartSheetOnLoaded(skus, skuItems, info)),
      child: BlocListener<ShoppingCartSheetBloc, ShoppingCartSheetState>(
        listener: (context, state) {
          if (state.error == ShoppingCartSheetError.unauthenticated) {
            showToast(state.error.message(context));
            Navigator.pop(context);
            RouterUtil.toLogin(context);
          } else if (state.error != ShoppingCartSheetError.noError) {
            showToast(state.error.message(context));
          } else if (state.snapshot.hasData) {
            showToast('添加成功');
            Navigator.pop(context);
          }
        },
        child: FractionallySizedBox(
          heightFactor: 0.75,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  basic,
                  Gaps.line,
                  Gaps.vGap16,
                  shipping,
                  Gaps.vGap16,
                  Gaps.line,
                  _ShoppingCartSkuWidget(
                    boldStyle: boldStyle,
                    textStyle: textStyle,
                  ),
                  Gaps.vGap16,
                  counter,
                  Gaps.vGap16,
                  Gaps.line,
                  SizedBox(
                    height: 44,
                  ),
                  button,
                  SizedBox(
                    height: 36,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShoppingCartSkuWidget extends StatelessWidget {
  const _ShoppingCartSkuWidget({Key key, this.boldStyle, this.textStyle})
      : super(key: key);

  final TextStyle boldStyle;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final selectedDecoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Color(0xff707070), width: 1),
      borderRadius: BorderRadius.circular(16),
    );
    final unselectedDecoration = selectedDecoration.copyWith(
      border: Border(),
      color: Colours.greyBackground,
    );
    final disableStyle = textStyle.copyWith(color: Colours.textGrey2);

    return BlocBuilder<ShoppingCartSheetBloc, ShoppingCartSheetState>(
      builder: (context, state) {
        return Column(
          children: state.items
              .map((e) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.vGap16,
                      Text(
                        e.name,
                        style: boldStyle,
                      ),
                      Gaps.vGap12,
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: e.items.map((e) {
                          final selected = state.selected.contains(e);
                          final disabled = state.disableItems.contains(e);
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (!disabled) {
                                context
                                    .read<ShoppingCartSheetBloc>()
                                    .add(ShoppingCartSheetSkuItemOnClicked(e));
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: selected
                                  ? selectedDecoration
                                  : unselectedDecoration,
                              child: Text(
                                e.name,
                                style: disabled ? disableStyle : textStyle,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Gaps.vGap16,
                      Gaps.line,
                    ],
                  ))
              .toList(),
        );
      },
    );
  }
}
