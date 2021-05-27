import 'package:flutter/material.dart';
import 'package:flutter_keep/components/notice/tabs/tabs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/widgets/widgets.dart';

enum NoticeType { all, discount, news, shipping, vacation }

extension on NoticeType {
  String text(BuildContext context) {
    switch (this) {
      case NoticeType.all:
        return '全部';
      case NoticeType.discount:
        return '优惠';
      case NoticeType.news:
        return '新品';
      case NoticeType.shipping:
        return '快递';
      case NoticeType.vacation:
        return '放假';
    }
    return '';
  }
}

final List<NoticeType> _values = NoticeType.values;

class NoticeListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle =
        TextStyles.text.copyWith(fontWeight: FontWeight.bold);
    final TextStyle unSelectStyle =
        labelStyle.copyWith(fontWeight: FontWeight.normal);
    return DefaultTabController(
      length: _values.length,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('公告'),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            TabBar(
              tabs: _values
                  .map(
                    (e) => Tab(
                      text: e.text(context),
                    ),
                  )
                  .toList(),
              labelColor: Colours.text,
              labelStyle: labelStyle,
              unselectedLabelStyle: unSelectStyle,
              indicatorColor: Colours.colorOpacity,
              indicatorWeight: 0.1,
            ),
            Expanded(
              child: TabBarView(
                key: const Key('notice_tab_view'),
                children: _values
                    .asMap()
                    .entries
                    .map(
                      (e) => NoticeTabBarView(
                        index: e.key,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
