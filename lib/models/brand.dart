// To parse this JSON data, do
//
//     final brand = brandFromMap(jsonString);

import 'dart:convert';

class Brand {
  Brand({
    this.id,
    this.brandName,
    this.pic,
  });

  final String id;
  final String brandName;
  final String pic;

  Brand copyWith({
    String id,
    String brandName,
    String pic,
  }) =>
      Brand(
        id: id ?? this.id,
        brandName: brandName ?? this.brandName,
        pic: pic ?? this.pic,
      );

  factory Brand.fromJson(String str) => Brand.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
        id: json["id"] == null ? null : json["id"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        pic: json["pic"] == null ? null : json["pic"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "brand_name": brandName == null ? null : brandName,
        "pic": pic == null ? null : pic,
      };
}
