import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as ex;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/components/screens/home/blocs/blocs.dart';

class ActivityTabView extends StatefulWidget {
  const ActivityTabView({Key key, @required this.index}) : super(key: key);

  final int index;

  @override
  _ActivityTabViewState createState() => _ActivityTabViewState();
}

class _ActivityTabViewState extends State<ActivityTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final EdgeInsets edge = EdgeInsets.all(20);
    final EdgeInsets bannerPadding = edge.copyWith(bottom: 0, top: 24);
    final EdgeInsets textPadding = bannerPadding.copyWith(bottom: 16);

    return BlocProvider(
      create: (_) =>
          ActivityBloc(repository: context.read<HomeScreenRepository>())
            ..add(ActivityOnLoaded()),
      child: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) => state.status.when(
          context,
          builder: (context) => ex.NestedScrollViewInnerScrollPositionKeyWidget(
            Key('home_tab${widget.index}'),
            Container(
              color: Colours.greyBackground,
              child: CustomScrollView(
                key: PageStorageKey<String>('home_tab_view${widget.index}'),
                slivers: [
                  SliverOverlapInjector(
                    handle: ex.NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  _ActivityBanner(
                    key: Key('activity_banner'),
                    aspectRatio: 1.558,
                    padding: bannerPadding,
                    banners: state.result.banners,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  SliverPadding(
                    padding: textPadding,
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        '人气热销',
                        style: TextStyles.textBold20,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: edge.copyWith(
                      top: 0,
                    ),
                    sliver: SliverGrid(
                      key: const Key('activity_grid'),
                      gridDelegate: ProductItemWidget.withGridDelegate(),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = state.result.products[index];
                          return ProductItemWidget(
                            key: Key('${widget.index}home_list_item$index'),
                            product: item,
                          );
                        },
                        childCount: state.result.products.length,
                      ),
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

  @override
  bool get wantKeepAlive => true;
}

class _ActivityBanner extends StatelessWidget {
  const _ActivityBanner(
      {Key key,
      this.padding,
      this.aspectRatio,
      this.borderRadius,
      this.banners})
      : super(key: key);

  final List<Notice> banners;

  final double aspectRatio;

  final EdgeInsetsGeometry padding;

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(
        child: CarouselSlider(
          items: banners
              .map(
                (e) => GestureDetector(
                  key: Key('activity_banner${e.id}'),
                  onTap: () => RouterUtil.toNotice(context, e.id),
                  child: ClipRRect(
                    child: FadeInImage(
                      image: AssetImage(e.pic),
                      fit: BoxFit.cover,
                      placeholder: R.assets.imagePlaceholder,
                    ),
                    borderRadius: borderRadius,
                  ),
                ),
              )
              .toList(),
          options:
              CarouselOptions(viewportFraction: 1.0, aspectRatio: aspectRatio),
        ),
      ),
    );
  }
}
