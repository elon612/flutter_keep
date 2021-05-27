import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class ProductBasicView extends StatelessWidget {
  const ProductBasicView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyles.text;
    final unitStyle = textStyle.copyWith(fontSize: 12);
    final titleStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
    final priceStyle =
        textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 24);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(
        top: 16,
        left: 12,
        right: 12,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              R.assets.productBrandIcon.image(),
              Gaps.hGap4,
              Text(
                '女孩日记',
                style: TextStyle(
                  color: Colours.textGrey2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Gaps.vGap8,
          Text('修身H裙（S〜L）', style: titleStyle),
          Gaps.vGap8,
          Row(
            children: [
              Text(
                '¥',
                style: unitStyle,
              ),
              Gaps.hGap4,
              Text(
                '69',
                style: priceStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
