import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class NoConnectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double halfWidth = size.width / 2;

    Widget icon = Icon(
      Icons.router,
      size: size.width / 6,
      color: Theme.of(context).iconTheme.color,
    );

    Widget text = Text(
      '检查网络连接',
      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20.0),
    );

    return Material(
      color: Colors.black26,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Center(
          child: Container(
            width: halfWidth,
            height: halfWidth,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [icon, Gaps.hGap4, text],
            ),
          ),
        ),
      ),
    );
  }
}
