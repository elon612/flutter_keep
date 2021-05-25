import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class OrderProductView extends StatelessWidget {
  const OrderProductView({Key key, this.carts}) : super(key: key);
  final List<ShoppingCartItem> carts;

  @override
  Widget build(BuildContext context) {
    final totalCount = carts.map((e) => e.number).reduce((a, b) => a + b);

    Widget horizontalListView = SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: carts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = carts[index];
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: _OrderProductItemView(
              item: item,
            ),
          );
        },
      ),
    );

    return GestureDetector(
      onTap: () => showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          enableDrag: false,
          isScrollControlled: true,
          builder: (context) => _OrderProductBottomSheet(
                items: carts,
              )),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          horizontalListView,
          Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 100,
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0x00ffffff),
                    Color(0x00ffffff),
                    Color(0xffffffff),
                  ]),
                ),
                child: Text(
                  '共$totalCount件',
                  style: TextStyle(color: Color(0xffb3b3b3), fontSize: 12),
                ),
              ))
        ],
      ),
    );
  }
}

class _OrderProductBottomSheet extends StatelessWidget {
  const _OrderProductBottomSheet({Key key, this.items}) : super(key: key);
  final List<ShoppingCartItem> items;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 16),
              child: Text(
                '商品清单',
                style: TextStyles.text.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: items
                    .map((e) => _OrderBottomSheetItemView(
                          item: e,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderProductItemView extends StatelessWidget {
  const _OrderProductItemView({Key key, this.item}) : super(key: key);
  final ShoppingCartItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox.fromSize(
        size: Size.square(80),
        child: FadeInImage(
          image: AssetImage(item.pic),
          placeholder: R.assets.imagePlaceholder,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _OrderBottomSheetItemView extends StatelessWidget {
  const _OrderBottomSheetItemView({Key key, this.item}) : super(key: key);
  final ShoppingCartItem item;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyles.text;
    final TextStyle priceStyle =
        textStyle.copyWith(fontWeight: FontWeight.bold);
    final TextStyle otherStyle =
        TextStyles.text12.copyWith(color: Colours.textGrey);
    return Column(
      children: [
        Gaps.vGap16,
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox.fromSize(
                size: Size.square(80),
                child: FadeInImage(
                  image: AssetImage(item.pic),
                  placeholder: R.assets.imagePlaceholder,
                ),
              ),
            ),
            Gaps.hGap20,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: textStyle,
                  maxLines: 2,
                ),
                Text(
                  item.propValue,
                  style: otherStyle,
                ),
                Gaps.vGap8,
                Row(
                  children: [
                    Text(
                      '¥ ${item.price}',
                      style: priceStyle,
                    ),
                    Spacer(),
                    Text(
                      'x${item.number}',
                      style: otherStyle,
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
        Gaps.vGap16,
        Divider(
          height: 1,
          color: Colours.greyBackground,
        ),
      ],
    );
  }
}
