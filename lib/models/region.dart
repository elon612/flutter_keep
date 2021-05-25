import 'dart:convert';

class Region {
  Region({
    this.regionId,
    this.regionName,
    this.children,
  });

  final String regionId;
  final String regionName;
  final List<Region> children;

  Region copyWith({
    String regionId,
    String regionName,
    List<Region> children,
  }) =>
      Region(
        regionId: regionId ?? this.regionId,
        regionName: regionName ?? this.regionName,
        children: children ?? this.children,
      );

  factory Region.fromJson(String str) => Region.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Region.fromMap(Map<String, dynamic> json) => Region(
    regionId: json["region_id"] == null ? null : json["region_id"],
    regionName: json["region_name"] == null ? null : json["region_name"],
    children: json["children"] == null
        ? null
        : List<Region>.from(json["children"].map((x) => Region.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "region_id": regionId == null ? null : regionId,
    "region_name": regionName == null ? null : regionName,
    "children": children == null
        ? null
        : List<dynamic>.from(children.map((x) => x.toMap())),
  };
}
