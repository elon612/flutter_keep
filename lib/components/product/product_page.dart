import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/components/product/blocs/blocs.dart';
import 'package:flutter_keep/components/product/tabs/tabs.dart';
import 'package:flutter_keep/components/product/views/views.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as ex;
import 'package:oktoast/oktoast.dart';
import 'package:flutter_keep/components/common/common.dart';

extension on ProductError {
  bool get hasError => this != ProductError.noError;

  String text(BuildContext context) {
    switch (this) {
      case ProductError.noAuth:
        return '你还未登录';
      default:
        return '';
    }
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({Key key, this.productId}) : super(key: key);

  final String productId;

  Widget get gapWrapper => SliverToBoxAdapter(
        child: Gaps.vGap20,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        repository: context.read<ProductRepository>(),
        userRepository: context.read<UserRepository>(),
        bloc: context.read<AuthenticationBloc>(),
      )..add(ProductOnLoaded(productId)),
      child: Scaffold(
        body: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state.error.hasError) {
              showToast(state.error.text(context));
              RouterUtil.toLogin(context);
            }
          },
          builder: (context, state) =>
              state.status.when(context, builder: (context) {
            ProductDetailInfo info = state.detailInfo;
            List<String> images = info.productImages;
            List<String> detailImages = info.productDetailImages;
            return Column(
              children: [
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: ex.NestedScrollView(
                      key: const Key('product_scroll_view'),
                      headerSliverBuilder: (context, _) => [
                        ProductHeaderView(
                          key: const Key('product_header_view'),
                          images: images,
                          collected: state.collected,
                        ),
                        gapWrapper,
                        ProductBasicView(
                          key: const Key('product_basic_view'),
                        ),
                        gapWrapper,
                        CustomTabBar(
                          key: const Key('product_tab_bar'),
                        ),
                      ],
                      body: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TabBarView(
                          key: const Key('product_tab_bar_view'),
                          children: [
                            ImageTabView(
                              images: detailImages,
                            ),
                            InfoTabView(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ProductBottomBar(
                  key: const Key('product_bottom_bar'),
                  info: info,
                  collected: state.collected,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
