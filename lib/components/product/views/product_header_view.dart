import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_keep/components/product/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/gaps.dart';

class ProductHeaderView extends StatefulWidget {
  const ProductHeaderView({Key key, this.images, this.collected})
      : super(key: key);
  final bool collected;
  final List<String> images;

  @override
  _ProductHeaderViewState createState() => _ProductHeaderViewState();
}

class _ProductHeaderViewState extends State<ProductHeaderView> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            child: CarouselSlider(
                items: widget.images
                    .map((e) => FadeInImage(
                          image: AssetImage(e),
                          fit: BoxFit.cover,
                          placeholder: R.assets.imagePlaceholder,
                        ))
                    .toList(),
                options: CarouselOptions(
                    viewportFraction: 1.0,
                    aspectRatio: 1.0,
                    onPageChanged: (index, _) {
                      setState(() {
                        _current = index;
                      });
                    })),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 8,
            left: 20,
            right: 20,
            child: Row(
              children: [
                _ActionButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                Spacer(),
                _ActionButton(
                  icon: widget.collected
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () => context.read<ProductBloc>().add(
                        ProductCollectionOnClicked(),
                      ),
                ),
                Gaps.hGap8,
                _ActionButton(
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () => RouterUtil.toShoppingCartPage(context),
                ),
                Gaps.hGap8,
                // _ActionButton(
                //   icon: Icon(Icons.share_outlined),
                //   onPressed: () => {},
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key key, this.icon, this.onPressed}) : super(key: key);
  final Icon icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colours.text, borderRadius: BorderRadius.circular(14)),
        width: 28,
        height: 28,
        child: IconButton(
          icon: icon,
          color: Colors.white,
          iconSize: 12,
          padding: EdgeInsets.zero,
          onPressed: onPressed,
        ));
  }
}
