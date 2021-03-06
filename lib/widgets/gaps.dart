import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';

class Gaps {
  /// 水平间隔
  static const Widget hGap4 = SizedBox(width: Dimens.gap4);
  static const Widget hGap5 = SizedBox(width: Dimens.gap5);
  static const Widget hGap8 = SizedBox(width: Dimens.gap8);
  static const Widget hGap10 = SizedBox(width: Dimens.gap10);
  static const Widget hGap12 = SizedBox(width: Dimens.gap12);
  static const Widget hGap15 = SizedBox(width: Dimens.gap15);
  static const Widget hGap16 = SizedBox(width: Dimens.gap16);
  static const Widget hGap20 = SizedBox(width: Dimens.gap20);
  static const Widget hGap32 = SizedBox(width: Dimens.gap32);

  /// 垂直间隔
  static const Widget vGap4 = SizedBox(height: Dimens.gap4);
  static const Widget vGap5 = SizedBox(height: Dimens.gap5);
  static const Widget vGap8 = SizedBox(height: Dimens.gap8);
  static const Widget vGap10 = SizedBox(height: Dimens.gap10);
  static const Widget vGap12 = SizedBox(height: Dimens.gap12);
  static const Widget vGap15 = SizedBox(height: Dimens.gap15);
  static const Widget vGap16 = SizedBox(height: Dimens.gap16);
  static const Widget vGap20 = SizedBox(height: Dimens.gap20);
  static const Widget vGap24 = SizedBox(height: Dimens.gap24);
  static const Widget vGap32 = SizedBox(height: Dimens.gap32);
  static const Widget vGap50 = SizedBox(height: Dimens.gap50);

  static const Widget line = Divider();

  static const Widget vLine = SizedBox(
    width: 0.6,
    height: 24.0,
    child: VerticalDivider(),
  );

  static const Widget empty = SizedBox.shrink();
}
