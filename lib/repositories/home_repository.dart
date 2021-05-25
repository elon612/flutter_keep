import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';

class HomeRepository {
  // 模仿 http 请求

  /// 获取公告信息 [本地模拟]
  Future<List<Notice>> getNotices() async {
    await delay05s();
    final bundles = await rootBundle.loadString(R.json.announcement);
    final data = json.decode(bundles) as List<dynamic>;
    return data.map((e) => Notice.fromMap(e)).toList();
  }

  /// 根据 [index] 查找公告 [本地模拟]
  Future<List<Notice>> getNoticesBy(int index) async {
    await delay05s();
    final bundles = await rootBundle.loadString(R.json.announcement);
    final data = json.decode(bundles) as List<dynamic>;
    return data
        .map((e) => Notice.fromMap(e))
        .where((e) => index == 0 || e.type == index)
        .toList();
  }

  /// 根据 [id] 查找公告 [本地模拟]
  Future<Notice> getNoticeBy(int id) async {
    await delay05s();
    final bundles = await rootBundle.loadString(R.json.announcement);
    final data = json.decode(bundles) as List<dynamic>;
    return data
        .map((e) => Notice.fromMap(e))
        .toList()
        .firstWhere((e) => e.id == id);
  }
}
