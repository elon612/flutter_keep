// To parse this JSON data, do
//
//     final shipping = shippingFromMap(jsonString);

import 'dart:convert';

class ShippingItem {
  ShippingItem({
    this.shippingId,
    this.shippingName,
  });

  final String shippingId;
  final String shippingName;

  ShippingItem copyWith({
    String shippingId,
    String shippingName,
  }) =>
      ShippingItem(
        shippingId: shippingId ?? this.shippingId,
        shippingName: shippingName ?? this.shippingName,
      );

  factory ShippingItem.fromJson(String str) =>
      ShippingItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShippingItem.fromMap(Map<String, dynamic> json) => ShippingItem(
        shippingId: json["shipping_id"] == null ? null : json["shipping_id"],
        shippingName:
            json["shipping_name"] == null ? null : json["shipping_name"],
      );

  Map<String, dynamic> toMap() => {
        "shipping_id": shippingId == null ? null : shippingId,
        "shipping_name": shippingName == null ? null : shippingName,
      };
}
