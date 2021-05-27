import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/models/shipping_item.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/utils/utils.dart';

class LimitExceededException implements Exception {}

/// enum

enum OrderType {
  all,
  unPay,
  completed,
  canceled,
}

/// action

enum AddressStreamAction {
  refresh,
  addressEmpty,
}

/// extension

extension on OrderType {
  String get query {
    switch (this) {
      case OrderType.all:
        return null;
      case OrderType.unPay:
        return 'unpay';
      case OrderType.completed:
        return 'completed';
      case OrderType.canceled:
        return 'canceled';
    }
    return '';
  }

  String get key {
    switch (this) {
      case OrderType.all:
        return '';
      case OrderType.unPay:
        return '0';
      case OrderType.completed:
        return '1';
      case OrderType.canceled:
        return '-1';
    }
    return '';
  }
}

/// 模拟

class UserRepository {
  final ProductRepository productRepository;
  UserRepository({this.productRepository});

  User _user;
  List<Address> _addresses;
  List<ShoppingCartItem> _carts;
  List<OrderItem> _orderItems;

  /// getter

  Future<List<Address>> get addresses async {
    _addresses ??= await _getAddresses();
    return _addresses;
  }

  Future<List<ShoppingCartItem>> get shoppingCarts async {
    _carts ??= await _shoppingCarts();
    return _carts;
  }

  Future<List<OrderItem>> ordersBy(OrderType type) async {
    _orderItems ??= await _orders(type);
    return _orderItems
        .where((e) => type.key.isEmpty || e.orderStatus == type.key)
        .toList();
  }

  /// stream notify

  Stream<void> get notify => _cartStreamController.stream;
  Stream<AddressStreamAction> get addressStream =>
      _addressStreamController.stream;
  Stream<void> get orderStream => _orderStreamController.stream;

  StreamController<void> _cartStreamController =
      StreamController<void>.broadcast();
  StreamController<AddressStreamAction> _addressStreamController =
      StreamController<AddressStreamAction>.broadcast();
  StreamController<void> _orderStreamController =
      StreamController<void>.broadcast();

  /// 控制

  void _cartRefresh() => _cartStreamController.add(null);
  void _orderRefresh() => _orderStreamController.add(null);
  void _addressRefresh() =>
      _addressStreamController.add(AddressStreamAction.refresh);
  void _addressEmpty() =>
      _addressStreamController.add(AddressStreamAction.addressEmpty);

  /// 释放控制器
  void dispose() {
    _cartStreamController.close();
    _addressStreamController.close();
    _orderStreamController.close();
  }

  /// 用户相关

  /// 获取用户
  User getUser() {
    if (_user != null) return _user;
    _user = getUserFromDisk();
    return _user;
  }

  /// 删除用户信息
  Future<void> clearUser() async {
    await HiveUtils.userBox.delete(R.strings.user);
    _user = null;
  }

  /// 保存到本地
  Future<void> toLocalStored(User user) async {
    // await HiveUtils.userBox.put(R.strings.user, user.toMap());
    _user = user;
  }

  static User getUserFromDisk() {
    final data = HiveUtils.userBox.get(R.strings.hiveUserBox);
    if (data != null) {
      return User.fromMap(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// 注册
  Future<void> register(
      String phone, String security, String name, String password) async {
    await delay1s();
  }

  /// 购物车

  /// 商品添加到购物车 [模拟下]
  Future<void> toCart(int skuId, int number, String productId) async {
    await delay1s();
    await shoppingCarts;
    final List<Sku> skus = await productRepository.getSkus();

    if (_carts.any((e) => e.skuId == skuId)) {
      // sku 存在于购物车
      _carts = _carts.map((e) {
        if (e.skuId == skuId) {
          final Sku sku = skus.firstWhere((e) => e.id == skuId);
          final int total = e.number + number;
          if (total > sku.stock) {
            throw LimitExceededException();
          }
          return e.copyWith(number: total);
        }
        return e;
      }).toList();
    } else {
      final Sku sku = skus.firstWhere((e) => e.id == skuId, orElse: () => null);
      if (sku != null) {
        final List<String> splits = sku.key.split('|').toList();
        List<SkuItem> skuItems = (await productRepository.getSkuItems())
            .expand((e) => e.items)
            .toList();
        final matched = skuItems
            .where((e) => splits.any((i) => e.id.toString() == i))
            .toList();
        matched.sort((a, b) => a.id - b.id);
        final String propValue = matched.map((e) => e.name).join(' ');
        String cartId = '1';
        if (_carts.isNotEmpty) {
          cartId = ((int.tryParse(_carts.last.cartId) ?? 1) + 1).toString();
        }

        ShoppingCartItem item = ShoppingCartItem(
          cartId: cartId,
          skuId: skuId,
          number: number,
          pic: R.json.images.productImage1.assetName,
          productName: '修身H裙（S〜L）',
          price: double.tryParse(sku.price),
          propValue: propValue,
        );
        _carts = [..._carts, item];
      }
    }

    _cartRefresh();
  }

  /// 购物车列表
  Future<List<ShoppingCartItem>> _shoppingCarts() async {
    final bundles = await rootBundle.loadString(R.json.shoppingCarts);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => ShoppingCartItem.fromMap(e)).toList();
  }

  /// 更新购物车
  Future<void> updateCart(String cartId, int skuId, int number) async {
    final List<Sku> skus = await productRepository.getSkus();
    _carts = _carts.map((e) {
      if (e.cartId == cartId) {
        final sku = skus.firstWhere((e) => e.id == skuId, orElse: () => null);
        if (sku.stock > number) {
          return e.copyWith(number: number);
        } else {
          throw LimitExceededException();
        }
      }
      return e;
    }).toList();
    await delay01s();
  }

  /// 删除购物车商品
  Future<void> deleteCart(String cartId) async {
    _carts = _carts.where((e) => e.cartId != cartId).toList();
    await delay01s();
  }

  /// 订单

  /// 生成订单
  Future<String> toOrder(
      String cartIds, String shippingId, String addressId) async {
    await delay1s();
    final List<String> splits = cartIds.split(',');
    final contained = _carts.where((e) => splits.contains(e.cartId)).toList();
    _carts = _carts.where((e) => !contained.contains(e)).toList();

    /// 模拟创建个订单

    int orderId = 1;
    int totalCount = 0;
    double productAmount = 0.0;
    contained.forEach((e) {
      totalCount += e.number;
      productAmount += (e.price * e.number);
    });

    final DateTime now = DateTime.now();
    final addTime = now.millisecondsSinceEpoch.toString();
    final String orderSn = formatDate(now, [yyyy, mm, dd, hh, nn, ss]);

    await ordersBy(OrderType.all);
    final address = _addresses.firstWhere((e) => e.addrId == addressId);
    final shippingItem =
        (await shippingList()).firstWhere((e) => e.shippingId == shippingId);
    final int shippingFee =
        await getShippingFee(shippingId, addressId, totalCount);
    final String orderAmount = (shippingFee + productAmount).toString();
    if (_orderItems.isNotEmpty) {
      orderId = int.tryParse(_orderItems.last.orderId) + 1;
    }
    final item = OrderItem(
      orderId: orderId.toString(),
      orderSn: orderSn,
      addTime: addTime,
      address: address,
      orderAmount: orderAmount,
      shipping: shippingItem,
      shippingFee: shippingFee.toString(),
      productAmount: productAmount.toString(),
      orderStatus: '0',
      orderStatusText: '待付款',
      items: contained,
    );

    _orderItems = [..._orderItems, item];
    _cartRefresh();
    _orderRefresh();

    return item.orderId;
  }

  /// 获取物流信息
  Future<List<ShippingItem>> shippingList() async {
    final bundles = await rootBundle.loadString(R.json.shippings);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => ShippingItem.fromMap(e)).toList();
  }

  /// 获取物流价格
  Future<int> getShippingFee(
      String shippingId, String addressId, int totalCount) async {
    if (totalCount > 20) return 0;
    if (shippingId == '1') {
      return 10;
    } else if (shippingId == '2') {
      return 8;
    } else if (shippingId == '3') {
      return 20;
    } else {
      return 0;
    }
  }

  /// 订单列表
  /// [orderType] 类型
  Future<List<OrderItem>> _orders(OrderType orderType, {int page = 1}) async {
    await delay1s();
    final Map<String, dynamic> query = <String, dynamic>{};
    if (orderType.query != null) {
      query['type'] = orderType.query;
    }
    query['page'] = page;
    final String data = await rootBundle.loadString(R.json.orders);
    final decoded = json.decode(data) as List<dynamic>;
    return decoded.map((e) => OrderItem.fromMap(e)).toList();
  }

  /// 通过 [orderId] 获取订单信息
  Future<OrderItem> orderBy(String orderId) async {
    await delay1s();
    return _orderItems.firstWhere((e) => e.orderId == orderId,
        orElse: () => null);
  }

  /// 订单取消
  Future<void> orderCancel(String orderId) async {
    await delay05s();
    OrderItem found =
        _orderItems.firstWhere((e) => e.orderId == orderId, orElse: () => null);
    if (found != null) {
      found = found.copyWith(
          orderStatusText: '已取消', orderStatus: OrderType.canceled.key);
      _orderItems = _orderItems
          .map((e) => e.orderId == found.orderId ? found : e)
          .toList();
      _orderRefresh();
    }
  }

  /// 支付
  Future<void> onPay(String orderId) async {
    await delay1s();
    OrderItem found =
        _orderItems.firstWhere((e) => e.orderId == orderId, orElse: () => null);
    if (found != null) {
      found = found.copyWith(
          orderStatusText: '已完成', orderStatus: OrderType.completed.key);
      _orderItems = _orderItems
          .map((e) => e.orderId == found.orderId ? found : e)
          .toList();
      _orderRefresh();
    }
  }

  /// 地址

  /// 用户地址
  Future<List<Address>> _getAddresses() async {
    final bundles = await rootBundle.loadString(R.json.addresses);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Address.fromMap(e)).toList();
  }

  /// 删除地址
  Future<void> deleteAddress(String addressId) async {
    _addresses = _addresses.where((e) => e.addrId != addressId).toList();
    if (_addresses.length > 0 && _addresses.every((e) => e.isCheck == '0')) {
      Address first = _addresses.first;
      first = first.copyWith(isCheck: '1');
      _addresses =
          _addresses.map((e) => e.addrId == first.addrId ? first : e).toList();
    }
    if (_addresses.isEmpty) {
      _addressEmpty();
    }
    _addressRefresh();
  }

  /// 更新地址
  Future<void> updateAddress(
      String addressId,
      String provinceId,
      String cityId,
      String countyId,
      String address,
      String consignee,
      String mobile,
      String provinceName,
      String cityName,
      String countyName,
      bool hasDefault) async {
    Address found =
        _addresses.firstWhere((e) => e.addrId == addressId, orElse: () => null);
    if (found != null) {
      found = found.copyWith(
        provinceId: provinceId,
        cityId: cityId,
        countyId: countyId,
        provinceName: provinceName,
        cityName: cityName,
        countyName: countyName,
        address: address,
        mobile: mobile,
        isCheck: hasDefault || _addresses.length < 2 ? '1' : '0',
      );
      _addresses = _addresses.map((e) {
        if (e.addrId == found.addrId) return found;
        if (hasDefault && e.addrId != found.addrId && e.isCheck == '1') {
          return e.copyWith(isCheck: '0');
        }
        return e;
      }).toList();
      _addressRefresh();
    }
  }

  /// 添加地址
  Future<void> createAddress(
      String provinceId,
      String cityId,
      String countyId,
      String address,
      String consignee,
      String mobile,
      String provinceName,
      String cityName,
      String countyName,
      bool hasDefault) async {
    int id = 1;
    if (_addresses.isNotEmpty) {
      id = int.tryParse(_addresses.last.addrId) + 1;
    }

    final Address created = Address(
        addrId: id.toString(),
        consignee: consignee,
        provinceId: provinceId,
        cityId: cityId,
        countyId: countyId,
        provinceName: provinceName,
        cityName: cityName,
        countyName: countyName,
        address: address,
        mobile: mobile,
        isCheck: hasDefault || _addresses.isEmpty ? '1' : '0');
    _addresses = [..._addresses, created];
    if (hasDefault) {
      _addresses = _addresses.map((e) {
        if (e.isCheck == '1' && e != created) {
          return e.copyWith(isCheck: '0');
        }
        return e;
      }).toList();
    }
    _addressRefresh();
  }

  /// 地区
  Future<List<Region>> regions() async {
    final bundles = await rootBundle.loadString(R.json.regions);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Region.fromMap(e)).toList();
  }

  /// 商品详情

  /// 收藏
  Future<void> collected(String productId) async {
    final Set<String> collection = _getCollections();
    collection.add(productId);
    await _saveToCollections(collection);
  }

  /// 取消收藏
  Future<void> uncollected(String productId) async {
    final Set<String> collection = _getCollections();
    collection.remove(productId);
    await _saveToCollections(collection);
  }

  /// 是否已经收藏
  bool inCollection(String productId) {
    final Set<String> collection = _getCollections();
    return collection.contains(productId);
  }

  Set<String> _getCollections() {
    final Map<String, String> collections = Map<String, String>.from(
        HiveUtils.userBox.get(R.strings.hiveUserProductCollection) ?? {});
    return List<String>.from(collections.values).toSet();
  }

  Future<void> _saveToCollections(Set<String> collection) async {
    final Map<String, String> data = collection
        .toList()
        .asMap()
        .map((key, value) => MapEntry(key.toString(), value));
    await HiveUtils.userBox.put(R.strings.hiveUserProductCollection, data);
  }
}
