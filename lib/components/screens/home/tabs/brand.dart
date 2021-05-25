import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/screens/home/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as ex;

import 'package:flutter_keep/components/common/common.dart';

extension on BrandActionType {
  String text(BuildContext context) {
    switch (this) {
      case BrandActionType.recommend:
        return '推荐';
      case BrandActionType.normal:
        return '常规';
    }
    return '';
  }
}

class BrandTabView extends StatefulWidget {
  const BrandTabView({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _BrandTabViewState createState() => _BrandTabViewState();
}

class _BrandTabViewState extends State<BrandTabView>
    with AutomaticKeepAliveClientMixin {
  int get index => widget.index;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImage();
    });
    super.initState();
  }

  void _precacheImage() {
    [R.assets.homeBrandGrid, R.assets.homeBrandList]
        .map((e) => precacheImage(e, context))
        .toList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => BrandBloc(repository: context.read<HomeScreenRepository>())
        ..add(BrandOnLoaded()),
      child: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) => state.status.when(
          context,
          builder: (context) => ex.NestedScrollViewInnerScrollPositionKeyWidget(
            Key('home_tab$index'),
            Container(
              color: Colours.greyBackground,
              child: CustomScrollView(
                key: PageStorageKey<String>('home_tab_view${widget.index}'),
                slivers: [
                  SliverOverlapInjector(
                    handle: ex.NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  _BrandOptionBar(
                    key: const Key('brand_option_bar'),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    sliver: state.inGrid
                        ? _BrandGridView(
                            key: const Key('brand_grid'),
                            brands: state.brands,
                            onTap: _onTap,
                          )
                        : _BrandListView(
                            key: const Key('brand_list'),
                            brands: state.brands,
                            onTap: _onTap,
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(Brand item) => RouterUtil.toProductList(context, '100', '1');
}

class _BrandOptionBar extends StatelessWidget {
  const _BrandOptionBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 48, right: 74, top: 12),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            _BrandActionItem(
              type: BrandActionType.recommend,
            ),
            SizedBox(
              width: 35,
            ),
            _BrandActionItem(
              type: BrandActionType.normal,
            ),
            Spacer(),
            Container(
              width: 1,
              color: Color(0xffdbdbdb),
              height: 20,
            ),
            SizedBox(
              width: 60,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  context.read<BrandBloc>().add(BrandLayoutOnChanged()),
              child: BlocBuilder<BrandBloc, BrandState>(
                  builder: (context, state) => Row(
                        children: [
                          Text(
                            !state.inGrid ? '平铺' : '列表',
                            style: TextStyle(
                              color: Colours.textGrey,
                            ),
                          ),
                          Gaps.hGap8,
                          !state.inGrid
                              ? R.assets.homeBrandGrid.image()
                              : R.assets.homeBrandList.image(),
                        ],
                      )),
            )
          ],
        ),
      ),
    );
  }
}

class _BrandActionItem extends StatelessWidget {
  const _BrandActionItem({Key key, this.type}) : super(key: key);
  final BrandActionType type;

  @override
  Widget build(BuildContext context) {
    final style = TextStyles.text14.copyWith(fontWeight: FontWeight.bold);
    final unSelectStyle = style.copyWith(fontWeight: FontWeight.normal);

    return GestureDetector(
      onTap: () {
        context.read<BrandBloc>().add(BrandOrderOnChanged(type));
      },
      child: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) => Text(
          type.text(context),
          style: state.recommended == type ? style : unSelectStyle,
        ),
      ),
    );
  }
}

class _BrandGridView extends StatelessWidget {
  const _BrandGridView({Key key, this.brands, this.onTap}) : super(key: key);
  final List<Brand> brands;
  final void Function(Brand brand) onTap;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio: 1.40,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = brands[index];
          return GestureDetector(
            key: Key('brand_grid_item$index'),
            onTap: () => onTap(item),
            child: Column(
              children: [
                ClipRRect(
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: FadeInImage(
                      image: AssetImage(
                        item.pic,
                      ),
                      placeholder: R.assets.imagePlaceholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                Gaps.vGap8,
                Text(item.brandName,
                    style: TextStyles.text
                        .copyWith(fontWeight: FontWeight.bold, height: 1.375))
              ],
            ),
          );
        },
        childCount: brands.length,
      ),
    );
  }
}

class _BrandListView extends StatelessWidget {
  const _BrandListView({Key key, this.brands, this.onTap}) : super(key: key);
  final List<Brand> brands;
  final void Function(Brand brand) onTap;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = brands[index];
        return GestureDetector(
          key: Key('brand_list_item$index'),
          onTap: () => onTap(item),
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: Text(item.brandName),
              ),
              Divider(
                height: 0.1,
                color: Colors.white,
              ),
            ],
          ),
        );
      }, childCount: brands.length),
    );
  }
}
