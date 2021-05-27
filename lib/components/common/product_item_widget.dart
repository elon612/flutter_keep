import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class ProductItemWidget extends StatelessWidget {
  ProductItemWidget(
      {Key key,
      this.product,
      this.onTap,
      this.borderRadius = const BorderRadius.all(Radius.circular(12.0))})
      : super(key: key);

  final Product product;

  final void Function() onTap;

  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    Widget image = AspectRatio(
      aspectRatio: 0.78125,
      child: FadeInImage(
        image: AssetImage(product.url),
        fit: BoxFit.cover,
        placeholder: R.assets.imagePlaceholder,
      ),
    );

    Widget text = Text(
      product.title,
      maxLines: 1,
      style: TextStyles.text12,
    );

    Widget unit = Text('¥', style: TextStyles.text.copyWith(fontSize: 8));
    Widget price = Text(
      product.price,
      style: TextStyles.title,
    );

    Widget title = Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text,
            Spacer(),
            Row(
              children: [unit, Gaps.hGap4, price],
            )
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: () =>
          onTap != null ? onTap() : RouterUtil.toProduct(context, null),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [image, title],
          ),
        ),
      ),
    );
  }

  static SliverGridDelegate withGridDelegate({double childAspectRatio = 0.6}) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      );
}
