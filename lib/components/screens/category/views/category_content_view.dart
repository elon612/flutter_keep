import 'package:flutter/material.dart';
import 'package:flutter_keep/components/screens/category/views/category_left_side_view.dart';
import 'package:flutter_keep/components/screens/category/views/category_right_side_view.dart';
import 'package:flutter_keep/models/models.dart';

class CategoryContentView extends StatelessWidget {
  const CategoryContentView(
      {Key key, this.children, this.keys, this.scrollController})
      : super(key: key);

  final List<Category> children;
  final List<GlobalKey> keys;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            flex: 17,
            child: CategoryLeftSideView(
              keys: keys,
              categories: children,
              contentScrollController: scrollController,
            ),
          ),
          Expanded(
            flex: 50,
            child: CategoryRightSideView(
              keys: keys,
              scrollController: scrollController,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
