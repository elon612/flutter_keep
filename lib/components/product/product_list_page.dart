import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/components/product/blocs/product_list_bloc.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/category.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';

import 'package:flutter_keep/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key key, this.categoryId, this.brandId})
      : super(key: key);
  final String categoryId;
  final String brandId;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductListBloc(
        refreshController: _refreshController,
        repository: context.read<ProductRepository>(),
      )..add(ProductListOnLoaded(widget.brandId, widget.categoryId)),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('商品列表'),
          elevation: 4,
        ),
        body: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) => state.status.when(
            context,
            builder: (context) => _ProductListContentView(
              result: state.result,
              refreshController: _refreshController,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductListContentView extends StatelessWidget {
  const _ProductListContentView({Key key, this.result, this.refreshController})
      : super(key: key);
  final ListResult result;
  final RefreshController refreshController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.greyBackground,
      child: SmartRefresher(
        enablePullUp: true,
        controller: refreshController,
        onRefresh: () =>
            context.read<ProductListBloc>().add(ProductRefreshOnLoaded()),
        onLoading: () =>
            context.read<ProductListBloc>().add(ProductMoreListOnLoaded()),
        child: CustomScrollView(
          key: const Key('product_list_scroll_view'),
          slivers: [
            _CategoryWidget(
              categories: result.categories,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 7, bottom: 16, left: 20, right: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '人气热销',
                  style: TextStyles.title
                      .copyWith(height: 1.9, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: ProductItemWidget.withGridDelegate(),
                delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductItemWidget(
                          key: Key('product_list_item$index'),
                          product: result.products[index],
                        ),
                    childCount: result.products.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryWidget extends StatelessWidget {
  const _CategoryWidget({Key key, this.categories}) : super(key: key);
  final List<CategoryItem> categories;

  @override
  Widget build(BuildContext context) {
    return categories.isNotEmpty
        ? SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 230,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3125,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 18,
                  ),
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return GestureDetector(
                      key: Key('product_category_item$index'),
                      onTap: () => RouterUtil.toProductList(context, '1', null),
                      child: Column(
                        children: [
                          SizedBox.fromSize(
                            size: Size.square(80),
                            child: FadeInImage(
                              placeholder: R.assets.imagePlaceholder,
                              image: AssetImage(item.url),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Gaps.hGap4,
                          Text(item.title, style: TextStyles.text),
                        ],
                      ),
                    );
                  },
                  itemCount: categories.length,
                ),
              ),
            ),
          )
        : SliverToBoxAdapter(
            child: SizedBox(),
          );
  }
}
