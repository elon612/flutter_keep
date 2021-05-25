import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

import 'custom_flexible_space_bar.dart';

const _kAppBarExpandedHeight = kToolbarHeight + 32.0;

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({Key key, this.onTap, this.bottom})
      : super(key: key);

  final void Function() onTap;

  final Widget bottom;

  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  List<Widget> _buildActions(BuildContext context) {
    double t = _lerpWithFlexibleSpaceBar(context);
    List<Widget> actions = [];
    if (t == 0.0) {
      actions = [
        IconButton(
          icon: R.assets.homeActionMine.image(),
          onPressed: () => Application.mainKey.currentState.jumpToUser(),
        ),
        IconButton(
          icon: R.assets.homeActionNotice.image(),
          onPressed: () => RouterUtil.toNoticeList(context),
        ),
        IconButton(
          icon: R.assets.homeActionCart.image(),
          onPressed: () =>
              Application.mainKey.currentState.jumpToShoppingCart(),
        )
      ];
    } else {
      actions = [
        IconButton(
          icon: R.assets.homeActionNotice.image(),
          onPressed: () => RouterUtil.toNoticeList(context),
        ),
      ];
    }
    actions.add(SizedBox(
      width: 12,
    ));
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      primary: false,
      expandedHeight: _kAppBarExpandedHeight,
      pinned: true,
      floating: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: _HomeLogo(),
      centerTitle: false,
      bottom: widget.bottom,
      flexibleSpace: CustomFlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        title: _CustomAppBarWrapper(onTap: () => RouterUtil.toSearch(context)),
      ),
      actions: [
        Builder(
          builder: (context) {
            return Row(
              children: _buildActions(context),
            );
          },
        )
      ],
    );
  }
}

class _HomeLogo extends StatefulWidget {
  @override
  __HomeLogoState createState() => __HomeLogoState();
}

class __HomeLogoState extends State<_HomeLogo> {
  @override
  Widget build(BuildContext context) {
    double t = _lerpWithFlexibleSpaceBar(context);
    return IgnorePointer(
        child: t == 0.0
            ? R.assets.homeLogo.image()
            : R.assets.homePureLogo.image());
  }
}

double _lerpWithFlexibleSpaceBar(BuildContext context) {
  final FlexibleSpaceBarSettings settings =
      context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
  final double deltaExtent = settings.maxExtent - settings.minExtent;
  return (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
      .clamp(0.0, 1.0);
}

class _CustomAppBarWrapper extends StatefulWidget {
  const _CustomAppBarWrapper({Key key, this.onTap}) : super(key: key);
  final void Function() onTap;

  @override
  __CustomAppBarWrapperState createState() => __CustomAppBarWrapperState();
}

class __CustomAppBarWrapperState extends State<_CustomAppBarWrapper> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double t = _lerpWithFlexibleSpaceBar(context);

        final left = Tween<double>(begin: 20, end: 60).transform(t);
        final right = Tween<double>(begin: 20, end: 60).transform(t);
        final bottom = Tween<double>(begin: 0, end: 12).transform(t);

        return Padding(
          padding: EdgeInsets.only(left: left, right: right, bottom: bottom),
          child: SearchAppBar(
            color: Colours.greyBackground,
            onTap: widget.onTap,
            hintText: '搜索',
            circularBorder: 16,
            height: 32,
          ),
        );
      },
    );
  }
}
