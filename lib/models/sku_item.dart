import 'dart:convert';

class SkuItem {
  const SkuItem({this.id, this.name});

  final int id;
  final String name;

  SkuItem copyWith({int id, String name}) =>
      SkuItem(id: id ?? this.id, name: name ?? this.name);

  factory SkuItem.fromJson(String str) => SkuItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
      };

  factory SkuItem.fromMap(Map<String, dynamic> json) => SkuItem(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"]);
}

class SkuItems {
  const SkuItems({this.items, this.name});
  final List<SkuItem> items;
  final String name;

  SkuItems copyWith({List<SkuItem> items, String name}) =>
      SkuItems(items: items ?? this.items, name: name ?? this.name);

  factory SkuItems.fromJson(String str) => SkuItems.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "items": items == null
            ? null
            : List<dynamic>.from(items.map((e) => e.toMap())),
        "name": name == null ? null : name,
      };

  factory SkuItems.fromMap(Map<String, dynamic> json) => SkuItems(
      items: json["items"] == null
          ? null
          : List.from(json["items"].map((e) => SkuItem.fromMap(e))),
      name: json["name"] == null ? null : json["name"]);
}
