import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/components/screens/home/blocs/blocs.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as ex;

class ProductListTabView extends StatefulWidget {
  const ProductListTabView({Key key, this.index}) : super(key: key);
  final int index;

  @override
  _ProductListTabViewState createState() => _ProductListTabViewState();
}

class _ProductListTabViewState extends State<ProductListTabView>
    with AutomaticKeepAliveClientMixin {
  RefreshController _controller;

  int get index => widget.index;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _controller = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => OtherBloc(
          repository: context.read<HomeScreenRepository>(),
          controller: _controller)
        ..add(OtherOnLoaded(index)),
      child: BlocBuilder<OtherBloc, OtherState>(
        builder: (context, state) => state.status.when(
          context,
          builder: (context) => ex.NestedScrollViewInnerScrollPositionKeyWidget(
            Key('home_tab$index'),
            SmartRefresher(
              enablePullUp: true,
              enablePullDown: false,
              onLoading: () =>
                  context.read<OtherBloc>().add(OtherMoreOnLoaded(index)),
              controller: _controller,
              child: CustomScrollView(
                key: PageStorageKey<String>('home_tab_view${widget.index}'),
                slivers: [
                  SliverOverlapInjector(
                      handle:
                          ex.NestedScrollView.sliverOverlapAbsorberHandleFor(
                              context)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    sliver: ProductListWidget(
                      products: state.products,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
