// To parse this JSON data, do
//
//     final address = addressFromMap(jsonString);

import 'dart:convert';

class Address {
  Address({
    this.addrId,
    this.uid,
    this.consignee,
    this.provinceId,
    this.cityId,
    this.countyId,
    this.provinceName,
    this.cityName,
    this.countyName,
    this.address,
    this.mobile,
    this.isCheck,
  });

  final String addrId;
  final String uid;
  final String consignee;
  final String provinceId;
  final String cityId;
  final String countyId;
  final String provinceName;
  final String cityName;
  final String countyName;
  final String address;
  final String mobile;
  final String isCheck;

  Address copyWith({
    String addrId,
    String uid,
    String consignee,
    String provinceId,
    String cityId,
    String countyId,
    String provinceName,
    String cityName,
    String countyName,
    String address,
    String mobile,
    String isCheck,
  }) =>
      Address(
        addrId: addrId ?? this.addrId,
        uid: uid ?? this.uid,
        consignee: consignee ?? this.consignee,
        provinceId: provinceId ?? this.provinceId,
        cityId: cityId ?? this.cityId,
        countyId: countyId ?? this.countyId,
        provinceName: provinceName ?? this.provinceName,
        cityName: cityName ?? this.cityName,
        countyName: countyName ?? this.countyName,
        address: address ?? this.address,
        mobile: mobile ?? this.mobile,
        isCheck: isCheck ?? this.isCheck,
      );

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        addrId: json["addr_id"] == null ? null : json["addr_id"],
        uid: json["uid"] == null ? null : json["uid"],
        consignee: json["consignee"] == null ? null : json["consignee"],
        provinceId: json["province_id"] == null ? null : json["province_id"],
        cityId: json["city_id"] == null ? null : json["city_id"],
        countyId: json["county_id"] == null ? null : json["county_id"],
        provinceName:
            json["province_name"] == null ? null : json["province_name"],
        cityName: json["city_name"] == null ? null : json["city_name"],
        countyName: json["county_name"] == null ? null : json["county_name"],
        address: json["address"] == null ? null : json["address"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        isCheck: json["is_check"] == null ? null : json["is_check"],
      );

  Map<String, dynamic> toMap() => {
        "addr_id": addrId == null ? null : addrId,
        "uid": uid == null ? null : uid,
        "consignee": consignee == null ? null : consignee,
        "province_id": provinceId == null ? null : provinceId,
        "city_id": cityId == null ? null : cityId,
        "county_id": countyId == null ? null : countyId,
        "province_name": provinceName == null ? null : provinceName,
        "city_name": cityName == null ? null : cityName,
        "county_name": countyName == null ? null : countyName,
        "address": address == null ? null : address,
        "mobile": mobile == null ? null : mobile,
        "is_check": isCheck == null ? null : isCheck,
      };
}
