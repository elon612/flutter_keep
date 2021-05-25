import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/utils/utils.dart';

class ProductRepository {
  /// 清除搜索标签
  Future<void> cleanSearchHistory() => HiveUtils.userBox
      .put(R.strings.hiveUserSearchHistory, Map<String, String>());

  /// 获取搜历史标签
  List<String> getSearchTags() {
    final histories = Map<String, String>.from(
        HiveUtils.userBox.get(R.strings.hiveUserSearchHistory) ?? {});
    List<String> result = histories.values.toList();
    if (result.isEmpty) {
      result = ['T恤', '连衣裙', '衬衫', '短裙'];
    }
    return result;
  }

  /// 保存搜索历史
  Future<void> saveSearchHistories(List<String> histories) async {
    final data =
        histories.asMap().map((key, value) => MapEntry(key.toString(), value));
    await HiveUtils.userBox.put(R.strings.hiveUserSearchHistory, data);
  }

  /// 根据 [query] 查询商品
  Future<List<Product>> getProductsByQuery(String query) async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (query.length.isOdd) return [];
    final bundles = await rootBundle.loadString(R.json.product);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Product.fromMap(e)).toList();
  }

  /// sku items
  Future<List<SkuItems>> getSkuItems() async {
    final bundles = await rootBundle.loadString(R.json.skuItems);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map<SkuItems>((e) => SkuItems.fromMap(e)).toList();
  }

  /// skus
  Future<List<Sku>> getSkus() async {
    final bundles = await rootBundle.loadString(R.json.skus);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map<Sku>((e) => Sku.fromMap(e)).toList();
  }

  Future<List<String>> _getProductImages() async {
    final bundles = await rootBundle.loadString(R.json.productImages);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<List<String>> _getProductDetailImages() async {
    final bundles = await rootBundle.loadString(R.json.productDetailImages);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  /// 获取商品详情信息
  Future<ProductDetailInfo> getProductDetailInfo() async {
    final List<Sku> skus = await getSkus();
    final List<SkuItems> items = await getSkuItems();
    final List<String> productImages = await _getProductImages();
    final List<String> productDetailImages = await _getProductDetailImages();

    return ProductDetailInfo(
        productImages: productImages,
        productDetailImages: productDetailImages,
        skuItems: items,
        skus: skus);
  }

  Future<List<Product>> getProductsBy(
      {String categoryId,
      String brandId,
      String type,
      String order,
      int page,
      int pageSize}) async {
    final query = <String, dynamic>{};
    query['page'] = page;
    query['page_size'] = 20;
    if (categoryId != null) {
      query['category_id'] = categoryId;
    }
    if (brandId != null) {
      query['brand_id'] = brandId;
    }
    if (type != null) {
      query['type'] = type;
    }
    if (order != null) {
      query['order'] = order;
    }
    await Future.delayed(Duration(milliseconds: 1000));
    final bundles = await rootBundle.loadString(R.json.product);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Product.fromMap(e)).toList();
  }

  /// 获取品牌类目
  Future<List<CategoryItem>> getBrandCategories(String brandId) async {
    if (brandId == null) return [];
    final bundles = await rootBundle.loadString(R.json.categoriesJson);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Category.fromMap(e)).toList()[3].children;
  }
}

class ProductDetailInfo {
  /// sku 列表
  final List<Sku> skus;

  /// sku 属性列表
  final List<SkuItems> skuItems;

  /// 主图
  final List<String> productImages;

  /// 详情图
  final List<String> productDetailImages;

  ProductDetailInfo(
      {this.productImages, this.productDetailImages, this.skus, this.skuItems});
}

class ListResult extends Equatable {
  const ListResult({this.products, this.categories});
  final List<Product> products;
  final List<CategoryItem> categories;

  ListResult copyWith({List<Product> products, List<Category> categories}) =>
      ListResult(
        products: products ?? this.products,
        categories: categories ?? this.categories,
      );

  @override
  List<Object> get props => [products, categories];
}
