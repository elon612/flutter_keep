import 'dart:convert';

class ShoppingCartItem {
  ShoppingCartItem({
    this.cartId,
    this.prdId,
    this.skuId,
    this.number,
    this.pic,
    this.productName,
    this.price,
    this.propValue,
  });

  final String cartId;
  final String prdId;
  final int skuId;
  final int number;
  final String propValue;
  final String pic;
  final String productName;
  final double price;

  ShoppingCartItem copyWith({
    String cartId,
    String prdId,
    int skuId,
    int number,
    String pic,
    String productName,
    String price,
    double propValue,
  }) =>
      ShoppingCartItem(
        cartId: cartId ?? this.cartId,
        prdId: prdId ?? this.prdId,
        skuId: skuId ?? this.skuId,
        number: number ?? this.number,
        pic: pic ?? this.pic,
        productName: productName ?? this.productName,
        price: price ?? this.price,
        propValue: propValue ?? this.propValue,
      );

  factory ShoppingCartItem.fromJson(String str) =>
      ShoppingCartItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShoppingCartItem.fromMap(Map<String, dynamic> json) =>
      ShoppingCartItem(
        cartId: json["cart_id"] == null ? null : json["cart_id"],
        prdId: json["prd_id"] == null ? null : json["prd_id"],
        skuId: json["sku_id"] == null ? null : json["sku_id"],
        number: json["number"] == null ? null : json["number"],
        pic: json["pic"] == null ? null : json["pic"],
        productName: json["product_name"] == null ? null : json["product_name"],
        price: json["price"] == null ? null : json["price"],
        propValue: json["prop_value"] == null ? null : json["prop_value"],
      );

  Map<String, dynamic> toMap() => {
        "cart_id": cartId == null ? null : cartId,
        "prd_id": prdId == null ? null : prdId,
        "sku_id": skuId == null ? null : skuId,
        "number": number == null ? null : number,
        "prop_value": propValue == null ? null : propValue,
        "pic": pic == null ? null : pic,
        "product_name": productName == null ? null : productName,
        "price": price == null ? null : price,
      };
}
