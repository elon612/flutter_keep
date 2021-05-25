import 'package:flutter_keep/constants/constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'package:hive_flutter/hive_flutter.dart';

class HiveUtils {
  const HiveUtils._();

  static Box<Map<dynamic, dynamic>> userBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    userBox = await Hive.openBox<Map<dynamic, dynamic>>(
        '${R.strings.hivePrefix}${R.strings.hiveUserBox}');
  }

  /// 清理用户数据
  static Future<void> cleanUserData() async {
    await userBox.clear();
  }
}
