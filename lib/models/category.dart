// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'dart:convert';

class Category {
  Category({
    this.title,
    this.sideName,
    this.headName,
    this.type,
    this.children,
  });

  final String title;
  final String sideName;
  final String headName;
  final int type;
  final List<CategoryItem> children;

  Category copyWith({
    String title,
    String sideName,
    String headName,
    int type,
    List<CategoryItem> children,
  }) =>
      Category(
        title: title ?? this.title,
        sideName: sideName ?? this.sideName,
        headName: headName ?? this.headName,
        type: type ?? this.type,
        children: children ?? this.children,
      );

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        title: json["title"] == null ? null : json["title"],
        sideName: json["sideName"] == null ? null : json["sideName"],
        headName: json["headName"] == null ? null : json["headName"],
        type: json["type"] == null ? null : json["type"],
        children: json["children"] == null
            ? null
            : List<CategoryItem>.from(
                json["children"].map((x) => CategoryItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "title": title == null ? null : title,
        "sideName": sideName == null ? null : sideName,
        "headName": headName == null ? null : headName,
        "type": type == null ? null : type,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x.toMap())),
      };
}

class CategoryItem {
  CategoryItem({
    this.title,
    this.url,
    this.children,
  });

  final String title;
  final String url;
  final List<CategoryItem> children;

  CategoryItem copyWith({
    String title,
    String url,
    List<CategoryItem> children,
  }) =>
      CategoryItem(
        title: title ?? this.title,
        url: url ?? this.url,
        children: children ?? this.children,
      );

  factory CategoryItem.fromJson(String str) =>
      CategoryItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryItem.fromMap(Map<String, dynamic> json) => CategoryItem(
        title: json["title"] == null ? null : json["title"],
        url: json["url"] == null ? null : json["url"],
        children: json["children"] == null
            ? null
            : List<CategoryItem>.from(
                json["children"].map((x) => CategoryItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "title": title == null ? null : title,
        "url": url == null ? null : url,
        "children": children == null
            ? null
            : List<dynamic>.from(children.map((x) => x.toMap())),
      };
}
