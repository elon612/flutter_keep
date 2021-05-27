import 'package:flutter/material.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as ex;

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({Key key, this.controller}) : super(key: key);
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.of(context).padding.top;
    return SliverOverlapAbsorber(
      handle: ex.NestedScrollView.sliverOverlapAbsorberHandleFor(
        context,
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        sliver: SliverAppBar(
          toolbarHeight: 46.5 + top,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
          pinned: true,
          primary: false,
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              child: TabBar(
                  controller: controller,
                  indicatorWeight: 0.5,
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: ['图文详情', '规格参数']
                      .map((String name) => Tab(text: name))
                      .toList()),
            ),
          ),
        ),
      ),
    );
  }
}
