export 'dimens.dart';
export 'styles.dart';
export 'colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/styles.dart';
import 'package:flutter_keep/routers/routers.dart';

import 'colors.dart';
import 'gen/assets.gen.dart';
import 'strings.dart';

final Function() delay01s =
    () async => Future.delayed(Duration(milliseconds: 100));
final Function() delay05s =
    () async => Future.delayed(Duration(milliseconds: 500));
final Function delay1s =
    () async => Future.delayed(Duration(milliseconds: 1000));

class R {
  static ThemeData themeData = _getThemeData();

  static Strings get strings => Strings.values();

  static $AssetsDataGen get json => Assets.data;
  static $AssetsImagesGen get assets => Assets.images;

  static ThemeData _getThemeData() {
    final Color main = Colours.main;
    final TextStyle text = TextStyles.text14;
    return ThemeData(
      primaryColor: main,
      indicatorColor: main,
      textTheme: TextTheme(subtitle1: text, bodyText2: text, subtitle2: text),
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.white,
      ),
      pageTransitionsTheme: WebNoTransitions(),
    );
  }
}
