import 'package:flutter/material.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/models.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({Key key, this.products}) : super(key: key);
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = products[index];
        return ProductItemWidget(
          product: item,
        );
      }, childCount: products.length),
      gridDelegate: ProductItemWidget.withGridDelegate(),
    );
  }
}
