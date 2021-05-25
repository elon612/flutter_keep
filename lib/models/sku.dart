import 'dart:convert';

class Sku {
  const Sku({this.id, this.key, this.stock, this.price, this.userOriginPrice});

  final int id;
  final String key;
  final int stock;
  final String price;
  final String userOriginPrice;

  Sku copyWith({int id, String key, int stock, String price}) => Sku(
      id: id ?? this.id,
      key: key ?? this.key,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      userOriginPrice: userOriginPrice ?? this.userOriginPrice);

  factory Sku.fromJson(String str) => Sku.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "key": key == null ? null : key,
        "stock": stock == null ? null : stock,
        "price": price == null ? null : price,
        "userOriginPrice": userOriginPrice == null ? null : userOriginPrice
      };

  factory Sku.fromMap(Map<String, dynamic> json) => Sku(
        id: json["id"] == null ? null : json["id"],
        key: json["key"] == null ? null : json["key"],
        stock: json["stock"] == null ? null : json["stock"],
        price: json["price"] == null ? null : json["price"],
        userOriginPrice: json["user_origin_price"] == null
            ? null
            : json["user_origin_price"],
      );
}
