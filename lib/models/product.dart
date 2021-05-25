// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

class Product {
  Product({
    this.id,
    this.price,
    this.title,
    this.url,
  });

  final String id;
  final String price;
  final String title;
  final String url;

  Product copyWith({
    String id,
    String price,
    String title,
    String url,
  }) =>
      Product(
        id: id ?? this.id,
        price: price ?? this.price,
        title: title ?? this.title,
        url: url ?? this.url,
      );

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        price: json["price"] == null ? null : json["price"],
        title: json["title"] == null ? null : json["title"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "price": price == null ? null : price,
        "title": title == null ? null : title,
        "url": url == null ? null : url,
      };
}
