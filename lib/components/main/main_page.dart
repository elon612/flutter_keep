import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keep/components/screens/screens.dart';
import 'package:flutter_keep/constants/constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex;
  PageController _controller;

  /// 缓存图片
  void _preCacheImage() async {
    [
      R.assets.tabHome,
      R.assets.tabHomeActive,
      R.assets.tabCategory,
      R.assets.tabCategoryActive,
      R.assets.tabCart,
      R.assets.tabCartActive,
      R.assets.tabMine,
      R.assets.tabMineActive
    ].map((e) => precacheImage(e, context)).toList();
  }

  /// 回到首页
  void jumpToZero() => _jumpTo(0);

  /// 跳转到购物车
  void jumpToShoppingCart() => _jumpTo(2);

  /// 跳转到用户
  void jumpToUser() => _jumpTo(3);

  /// 跳转到指定页面
  void _jumpTo(int target) {
    assert(target >= 0 && target < 4);
    setState(() {
      _controller.jumpToPage(target);
      _currentIndex = target;
    });
  }

  @override
  void initState() {
    _currentIndex = 0;
    _controller = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preCacheImage();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        key: const Key('main_page_view'),
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          CategoryScreen(),
          ShoppingCartScreen(),
          UserScreen(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        activeColor: Colors.black,
        onTap: (index) => _jumpTo(index),
        items: [
          BottomNavigationBarItem(
            icon: R.assets.tabHome.image(),
            activeIcon: R.assets.tabHomeActive.image(),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: R.assets.tabCategory.image(),
            activeIcon: R.assets.tabCategoryActive.image(),
            label: '分类',
          ),
          BottomNavigationBarItem(
            icon: R.assets.tabCart.image(),
            activeIcon: R.assets.tabCartActive.image(),
            label: '购物车',
          ),
          BottomNavigationBarItem(
            icon: R.assets.tabMine.image(),
            activeIcon: R.assets.tabMineActive.image(),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
