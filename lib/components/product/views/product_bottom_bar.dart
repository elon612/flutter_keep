import 'package:flutter/material.dart';
import 'package:flutter_keep/components/product/blocs/blocs.dart';
import 'package:flutter_keep/components/screens/shopping_cart/shopping_cart_bottom_sheet.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/utils/utils.dart';
import 'package:flutter_keep/widgets/widgets.dart';

const String _url = 'https://flutter.cn';

class ProductBottomBar extends StatelessWidget {
  const ProductBottomBar({Key key, this.info, this.collected})
      : super(key: key);
  final ProductDetailInfo info;
  final bool collected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(offset: Offset(0, 3), blurRadius: 3),
      ]),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _FavoriteIcon(
            collected: collected,
            onTap: () =>
                context.read<ProductBloc>().add(ProductCollectionOnClicked()),
          ),
          Gaps.hGap16,
          _WebsiteIcon(
            onTap: () => Utils.launchUrl(_url).catchError(
                (e) => showSnackBar(context, content: Text(e.toString()))),
          ),
          Spacer(),
          _ActionButton(
            text: '加入购物车',
            onPressed: () => ShoppingCartBottomSheet.showBottomSheet(
                context, info.skus, info.skuItems, info),
          )
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key key, this.text, this.onPressed}) : super(key: key);
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 88,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            Color(0xff4d4d4d),
            Color(0xff3c3c3c),
          ])),
      child: TextButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _WebsiteIcon extends StatelessWidget {
  const _WebsiteIcon({Key key, this.onTap}) : super(key: key);
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.web_sharp,
            size: 20,
          ),
          Text(
            '官网',
            style: TextStyles.text12,
          ),
        ],
      ),
    );
  }
}

class _FavoriteIcon extends StatelessWidget {
  const _FavoriteIcon({Key key, this.onTap, this.collected}) : super(key: key);
  final void Function() onTap;
  final bool collected;
  final double size = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          collected
              ? Icon(
                  Icons.favorite,
                  size: size,
                )
              : Icon(
                  Icons.favorite_border,
                  size: size,
                ),
          Text(
            '收藏',
            style: TextStyles.text12,
          ),
        ],
      ),
    );
  }
}
