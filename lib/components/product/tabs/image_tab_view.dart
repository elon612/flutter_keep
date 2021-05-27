import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as ex;

class ImageTabView extends StatelessWidget {
  const ImageTabView({Key key, this.images}) : super(key: key);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ex.NestedScrollViewInnerScrollPositionKeyWidget(
        const Key('product_tab0'),
        CustomScrollView(
          physics: const ClampingScrollPhysics(),
          key: const PageStorageKey('product_image_tab'),
          slivers: [
            SliverOverlapInjector(
              handle:
                  ex.NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => FadeInImage(
                        placeholder: R.assets.imagePlaceholder,
                        fit: BoxFit.cover,
                        image: AssetImage(images[index]),
                      ),
                  childCount: images.length),
            ),
          ],
        ),
      ),
    );
  }
}
