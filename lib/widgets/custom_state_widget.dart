import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';

import 'gaps.dart';

class CustomStateWidget extends StatelessWidget {
  const CustomStateWidget(
      {Key key,
      @required this.type,
      this.image,
      this.text,
      this.action,
      this.actionText,
      this.actionOnTap})
      : super(key: key);

  final Widget image;

  final String text;

  final StateType type;

  final Widget action;

  final String actionText;

  final void Function() actionOnTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox.fromSize(
            size: Size.square(250),
            child: image ?? type.image,
          ),
          Gaps.vGap16,
          Text(
            text ?? type.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Color(0xffD2D5DC)),
          ),
          if (action != null || actionText != null) ...<Widget>[
            Gaps.vGap16,
            action ??
                _CustomStateDefaultAction(
                  actionOnTap: actionOnTap,
                  actionText: actionText,
                )
          ],
        ],
      ),
    );
  }
}

class _CustomStateDefaultAction extends StatelessWidget {
  const _CustomStateDefaultAction(
      {Key key, this.actionOnTap, this.actionText = ''})
      : super(key: key);

  final String actionText;

  final void Function() actionOnTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: actionOnTap,
      child: Text(
        actionText,
        style: TextStyles.text.copyWith(color: Colors.white),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        )),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 14, vertical: 4)),
        minimumSize: MaterialStateProperty.all(Size(88, 32)),
        backgroundColor: MaterialStateProperty.all(Colours.text),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

enum StateType {
  /// 订单
  order,

  /// 购物车
  cart,

  /// 地址
  address,

  /// 网络请求失败
  network,

  /// 加载中
  loading,

  /// 空
  empty
}

extension StateTypeExtension on StateType {
  String get text => <String>[
        '暂无订单记录',
        '购物车竟然是空的！',
        '您还没有收获地址',
        '网络请求失败，请重新加载',
        '',
        '您还未登陆',
      ][index];

  Widget get image => [
        R.assets.emptyOrder.image(),
        R.assets.emptyShoppingCart.image(),
        R.assets.emptyAddress.image(),
        Icon(Icons.wifi_lock),
        CupertinoActivityIndicator(),
        Container(),
      ][index];
}
