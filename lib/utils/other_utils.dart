import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
        BuildContext context,
        {Widget content}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: content,
    ));

class Utils {
  static Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '打开链接失败';
    }
  }

  static Future<void> launchTel(String number) async {
    final String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '拨号失败';
    }
  }
}
