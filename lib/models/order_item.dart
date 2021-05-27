// To parse this JSON data, do
//
//     final orderItem = orderItemFromMap(jsonString);

import 'dart:convert';

import 'address.dart';
import 'shipping_item.dart';
import 'shopping_cart_item.dart';

class OrderItem {
  OrderItem({
    this.orderId,
    this.orderSn,
    this.addTime,
    this.orderAmount,
    this.productAmount,
    this.payAmount,
    this.shippingFee,
    this.orderStatus,
    this.orderStatusText,
    this.address,
    this.shipping,
    this.items,
  });

  final String orderId;
  final String orderSn;
  final String addTime;
  final String orderAmount;
  final String productAmount;
  final String payAmount;
  final String shippingFee;
  final String orderStatus;
  final String orderStatusText;
  final Address address;
  final ShippingItem shipping;
  final List<ShoppingCartItem> items;

  OrderItem copyWith({
    String orderId,
    String orderSn,
    String addTime,
    String orderAmount,
    String productAmount,
    String payAmount,
    String shippingFee,
    String orderStatus,
    String orderStatusText,
    Address address,
    ShippingItem shipping,
    List<ShoppingCartItem> items,
  }) =>
      OrderItem(
        orderId: orderId ?? this.orderId,
        orderSn: orderSn ?? this.orderSn,
        addTime: addTime ?? this.addTime,
        orderAmount: orderAmount ?? this.orderAmount,
        productAmount: productAmount ?? this.productAmount,
        payAmount: payAmount ?? this.payAmount,
        shippingFee: shippingFee ?? this.shippingFee,
        orderStatus: orderStatus ?? this.orderStatus,
        orderStatusText: orderStatusText ?? this.orderStatusText,
        address: address ?? this.address,
        shipping: shipping ?? this.shipping,
        items: items ?? this.items,
      );

  factory OrderItem.fromJson(String str) => OrderItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderItem.fromMap(Map<String, dynamic> json) => OrderItem(
        orderId: json["order_id"] == null ? null : json["order_id"],
        orderSn: json["order_sn"] == null ? null : json["order_sn"],
        addTime: json["add_time"] == null ? null : json["add_time"],
        orderAmount: json["order_amount"] == null ? null : json["order_amount"],
        productAmount:
            json["product_amount"] == null ? null : json["product_amount"],
        payAmount: json["pay_amount"] == null ? null : json["pay_amount"],
        shippingFee: json["shipping_fee"] == null ? null : json["shipping_fee"],
        orderStatus: json["order_status"] == null ? null : json["order_status"],
        orderStatusText: json["order_status_text"] == null
            ? null
            : json["order_status_text"],
        address:
            json["address"] == null ? null : Address.fromMap(json["address"]),
        shipping: json["shipping"] == null
            ? null
            : ShippingItem.fromMap(json["shipping"]),
        items: json["items"] == null
            ? null
            : List<ShoppingCartItem>.from(
                json["items"].map((x) => ShoppingCartItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "order_id": orderId == null ? null : orderId,
        "order_sn": orderSn == null ? null : orderSn,
        "add_time": addTime == null ? null : addTime,
        "order_amount": orderAmount == null ? null : orderAmount,
        "product_amount": productAmount == null ? null : productAmount,
        "pay_amount": payAmount == null ? null : payAmount,
        "shipping_fee": shippingFee == null ? null : shippingFee,
        "order_status": orderStatus == null ? null : orderStatus,
        "order_status_text": orderStatusText == null ? null : orderStatusText,
        "address": address == null ? null : address.toMap(),
        "shipping": shipping == null ? null : shipping.toMap(),
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toMap())),
      };
}
