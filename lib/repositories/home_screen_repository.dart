import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';


class HomeScreenRepository {
  /// 获取banner信息
  Future<List<Notice>> _getBanners() async {
    await delay05s();
    final bundles = await rootBundle.loadString(R.json.banners);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Notice.fromMap(e)).toList();
  }

  /// 获取活动商品信息
  Future<List<Product>> _getActivityProducts() async {
    await delay05s();
    final bundles = await rootBundle.loadString(R.json.product);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Product.fromMap(e)).toList();
  }

  /// 获取活动页面信息
  Future<ActivityResult> getActivityInfo() async {
    await delay1s();
    final List<Future> futures = [_getBanners(), _getActivityProducts()];
    final List<dynamic> result = await Future.wait(futures);
    return ActivityResult(banners: result.first, products: result.last);
  }

  /// 获取品牌信息
  Future<List<Brand>> getBrands() async {
    await delay05s();
    final bundles = await rootBundle.loadString(R.json.brands);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Brand.fromMap(e)).toList();
  }

  /// 根据 [index] 获取商品
  Future<List<Product>> getProductsBy(int index, {int page = 1}) async {
    await delay05s();
    if (page > 1 && index.isOdd) return <Product>[];
    final bundles = await rootBundle.loadString(R.json.product);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Product.fromMap(e)).toList();
  }

  /// 获取类目
  Future<List<Category>> getCategories() async {
    await delay1s();
    final bundles = await rootBundle.loadString(R.json.categoriesJson);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Category.fromMap(e)).toList();
  }
}

class ActivityResult {
  final List<Notice> banners;
  final List<Product> products;
  ActivityResult({this.banners, this.products});
}
