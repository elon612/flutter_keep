import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

const int _columns = 3;
const double _space = 27.0;

final TextStyle _titleStyle = TextStyle(color: Colours.text);

class CategoryRightSideView extends StatelessWidget {
  const CategoryRightSideView(
      {Key key, this.scrollController, this.keys, this.children})
      : super(key: key);

  final List<GlobalKey> keys;
  final List<Category> children;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            ...children
                .map(
                  (e) => _RightSideItemView(
                      key:
                          Key('category_right_side_item${children.indexOf(e)}'),
                      item: e,
                      globalKey: keys[children.indexOf(e)],
                      onTap: () {
                        String categoryId;
                        String brandId;
                        if (e.type == 2) {
                          brandId = '1';
                        } else {
                          categoryId = '100';
                        }
                        RouterUtil.toProductList(context, categoryId, brandId);
                      }),
                )
                .toList(),
            SizedBox(
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}

class _RightSideItemView extends StatelessWidget {
  const _RightSideItemView({Key key, this.item, this.globalKey, this.onTap})
      : super(key: key);

  final Category item;
  final GlobalKey globalKey;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (item.type == 2) {
      return _RightSideMarketView(
        key: globalKey,
        item: item,
        onTap: onTap,
      );
    }
    return Column(
      key: globalKey,
      children: [
        Gaps.vGap20,
        Text(
          item.sideName,
          style: _titleStyle,
        ),
        Gaps.vGap12,
        LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            final width =
                ((constraints.maxWidth - (_columns - 1 + 2) * _space) / _columns).floorToDouble();
            return Container(
              margin: EdgeInsets.symmetric(horizontal: _space),
              width: constraints.maxWidth,
              child: Wrap(
                spacing: _space,
                runSpacing: _space,
                children: item.children.map((e) {
                  return GestureDetector(
                    key: Key(
                        'category_right_side_iitem${item.children.indexOf(e)}'),
                    onTap: onTap,
                    child: SizedBox(
                      width: width,
                      child: Column(
                        children: [
                          FadeInImage(
                            image: AssetImage(e.url),
                            placeholder: R.assets.imagePlaceholder,
                          ),
                          Gaps.vGap8,
                          Text(
                            e.title,
                            textAlign: TextAlign.center,
                            style: TextStyles.text12,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RightSideMarketView extends StatelessWidget {
  const _RightSideMarketView({Key key, this.onTap, this.item})
      : super(key: key);

  final void Function() onTap;
  final Category item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gaps.vGap20,
            Center(
              child: Text(
                item.title,
                style: _titleStyle,
              ),
            ),
            Gaps.vGap20,
            ...(item.children.map((e) {
              return GestureDetector(
                key: Key(
                    'category_right_market_item${item.children.indexOf(e)}'),
                onTap: onTap,
                child: Column(
                  children: [
                    ClipRRect(
                      child: FadeInImage(
                        placeholder: R.assets.imagePlaceholder,
                        image: AssetImage(e.url),
                        fit: BoxFit.fitWidth,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    Gaps.vGap10,
                  ],
                ),
              );
            }).toList()),
          ]),
    );
  }
}
