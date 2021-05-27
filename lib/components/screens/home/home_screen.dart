import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/screens/home/blocs/blocs.dart';
import 'package:flutter_keep/components/screens/home/tabs/tabs.dart';
import 'package:flutter_keep/components/screens/home/views/views.dart' as inner;
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as ex;
import 'package:flutter_keep/components/common/common.dart';

enum HomeTabType {
  activity,
  brand,
  best,
  clothing,
  shoes,
  makeup,
}

extension on HomeTabType {
  String text(BuildContext context) {
    switch (this) {
      case HomeTabType.activity:
        return '活动';
      case HomeTabType.brand:
        return '品牌';
      case HomeTabType.best:
        return '热销';
      case HomeTabType.clothing:
        return '女装';
      case HomeTabType.shoes:
        return '鞋子';
      case HomeTabType.makeup:
        return '化妆品';
    }
    return '';
  }
}

final List<HomeTabType> _values = HomeTabType.values;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(length: _values.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (_) => HomeBloc(repository: context.read<HomeRepository>())
            ..add(HomeOnLoaded()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.status.when(context,
                builder: (context) => ex.NestedScrollView(
                      key: const Key('home_scroll_view'),
                      physics: const ClampingScrollPhysics(),
                      headerSliverBuilder: (context, _) =>
                          _sliverBuilder(context, state.notices),
                      innerScrollPositionKeyBuilder: () =>
                          Key('home_tab${_tabController.index}'),
                      body: TabBarView(
                        key: const Key('home_tab_bar_view'),
                        controller: _tabController,
                        children: _values.asMap().entries.map((e) {
                          final int index = e.key;
                          final HomeTabType type = e.value;
                          if (type == HomeTabType.activity) {
                            return ActivityTabView(
                              key: const Key('home_activity_tab_bar'),
                              index: index,
                            );
                          } else if (type == HomeTabType.brand) {
                            return BrandTabView(
                              key: const Key('home_brand_tab_bar'),
                              index: index,
                            );
                          }
                          return ProductListTabView(
                            key: Key('home_other_tab_bar$index'),
                            index: index,
                          );
                        }).toList(),
                      ),
                    )),
          ),
        ),
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, List<Notice> notices) {
    return <Widget>[
      SliverPersistentHeader(
        delegate: SliverHeaderDelegate(
          height: 40,
          child: _NoticeBar(
            notices: notices,
            key: const Key('home_notice_bar'),
          ),
        ),
      ),
      SliverOverlapAbsorber(
        handle: ex.NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: inner.CustomSliverAppBar(
          key: const Key('home_custom_app_bar'),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverHeaderDelegate(
          height: 40,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 6),
                labelColor: Colours.text,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                unselectedLabelColor: Colours.textGrey,
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                controller: _tabController,
                indicator: inner.CustomUnderlineTabIndicator(
                  borderSide: BorderSide(),
                ),
                isScrollable: true,
                tabs: _values
                    .map(
                      (e) => Tab(
                        text: e.text(context),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    ];
  }
}

class _NoticeBar extends StatefulWidget {
  const _NoticeBar(
      {Key key,
      this.notices,
      this.stepOffset = 200.0,
      this.paddingLeft = 50.0,
      this.duration = const Duration(milliseconds: 3000)})
      : super(key: key);

  final List<Notice> notices;

  final Duration duration;

  final double stepOffset;

  final double paddingLeft;

  @override
  __NoticeBarState createState() => __NoticeBarState();
}

class __NoticeBarState extends State<_NoticeBar> {
  ScrollController _controller;
  Timer _timer;
  double _offset = 0.0;

  @override
  void initState() {
    _controller = ScrollController(initialScrollOffset: _offset);
    _timer = Timer.periodic(widget.duration, (timer) {
      double newOffset = _controller.offset + widget.stepOffset;
      if (newOffset != _offset) {
        _offset = newOffset;
        _controller.animateTo(_offset,
            duration: widget.duration, curve: Curves.linear);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          final item = widget.notices[(index % widget.notices.length)];
          return Padding(
            key: Key('notice_bar_item$index'),
            padding:
                EdgeInsets.only(right: widget.paddingLeft, top: 6, bottom: 6),
            child: Text(item.title),
          );
        },
      ),
    );
  }
}
