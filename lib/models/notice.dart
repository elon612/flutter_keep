// To parse this JSON data, do
//
//     final notice = noticeFromMap(jsonString);

import 'dart:convert';


class Notice {
  Notice({this.id, this.type, this.title, this.content, this.pic});

  final int id;
  final int type;
  final String title;
  final String content;
  final String pic;

  Notice copyWith(
          {int id, int type, String title, String content, String pic}) =>
      Notice(
          id: id ?? this.id,
          type: type ?? this.type,
          title: title ?? this.title,
          content: content ?? this.content,
          pic: pic ?? this.pic);

  factory Notice.fromJson(String str) => Notice.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notice.fromMap(Map<String, dynamic> json) => Notice(
      id: json["id"] == null ? null : json["id"],
      type: json["type"] == null ? null : json["type"],
      title: json["title"] == null ? null : json["title"],
      content: json["content"] == null ? null : json["content"],
      pic: json['pic'] == null ? null : json['pic']);

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "title": title == null ? null : title,
        "content": content == null ? null : content,
        "pic": pic == null ? null : pic
      };
}
