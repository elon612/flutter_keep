import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/routers/routers.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(R.assets.launch, context);
    });
    Future.delayed(
        Duration(milliseconds: 1500), () => RouterUtil.toMain(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Material(child: R.assets.launch.image(fit: BoxFit.cover));
}
