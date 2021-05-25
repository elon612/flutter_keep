import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';

class CategoryLeftSideView extends StatefulWidget {
  const CategoryLeftSideView(
      {Key key, this.categories, this.keys, this.contentScrollController})
      : super(key: key);
  final List<Category> categories;
  final List<GlobalKey> keys;
  final ScrollController contentScrollController;

  @override
  _CategoryLeftSideViewState createState() => _CategoryLeftSideViewState();
}

class _CategoryLeftSideViewState extends State<CategoryLeftSideView> {
  Category _selected;
  bool _scrolling = false;

  @override
  void initState() {
    _selected = widget.categories.first;
    final controller = widget.contentScrollController;
    controller.addListener(() {
      if (_scrolling) return;
      final index = widget.categories.indexOf(_selected);
      final offset = controller.offset;
      final offsets = _findItemOffsetY(widget.keys[index], offset);
      var newIndex = index;
      if (offset > offsets.last) {
        newIndex++;
      } else if (offset < offsets.first) {
        newIndex--;
      }
      if (newIndex == index) return;
      if (newIndex > widget.categories.length || newIndex < 0) return;
      setState(() {
        _selected = widget.categories[newIndex];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(16.0);
    final textStyle = TextStyle(
        color: Colours.text, fontSize: 16, fontWeight: FontWeight.bold);
    final unSelectTextStyle = textStyle.copyWith(fontWeight: FontWeight.normal);

    Widget selectedBar = Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      width: 3,
      child: Container(
        color: Colors.black,
      ),
    );

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
            children: widget.categories.asMap().entries.map((e) {
          final value = e.value;
          final target = widget.categories.indexOf(_selected);
          final checked = e.key == target;

          BorderRadiusGeometry borderRadius = BorderRadius.zero;
          if (target - 1 == e.key) {
            borderRadius = BorderRadius.only(
              bottomRight: radius,
            );
          } else if (target + 1 == e.key) {
            borderRadius = BorderRadius.only(
              topRight: radius,
            );
          }

          return GestureDetector(
            key: Key('category_left_side_item${e.key}'),
            behavior: HitTestBehavior.opaque,
            onTap: () => _sideOnTap(e.key),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: borderRadius,
                  child: Container(
                    height: 44.5,
                    decoration: BoxDecoration(
                      color: checked ? Colors.white : Colours.greyBackground,
                    ),
                    child: Center(
                      child: Text(
                        value.title,
                        style: checked ? textStyle : unSelectTextStyle,
                      ),
                    ),
                  ),
                ),
                if (checked) selectedBar
              ],
            ),
          );
        }).toList()),
      ),
    );
  }

  List<double> _findItemOffsetY(GlobalKey key, double offset) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    double appBarHeight =
        MediaQueryData.fromWindow(window).padding.top + kToolbarHeight;
    double minY =
        renderBox.localToGlobal(Offset.zero).dy + offset - appBarHeight;
    double maxY = minY + renderBox.size.height;
    return [minY, maxY];
  }

  void _sideOnTap(int index) {
    final lastIndex = widget.categories.indexOf(_selected);
    final item = widget.categories[index];
    double target = _findItemOffsetY(
            widget.keys[index], widget.contentScrollController.offset)
        .first;
    Duration duration =
        Duration(milliseconds: min(300, 150 * (index - lastIndex).abs()));
    if (duration <= Duration.zero) {
      duration = Duration(milliseconds: 100);
    }
    _scrolling = true;
    widget.contentScrollController
        .animateTo(target, duration: duration, curve: Curves.linear);
    setState(() {
      _selected = item;
    });
    Future.delayed(duration, () {
      _scrolling = false;
    });
  }
}
