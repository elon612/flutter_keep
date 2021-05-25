import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/notice/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/router_util.dart';
import 'package:flutter_keep/widgets/widgets.dart';

import 'package:flutter_keep/components/common/common.dart';

class NoticeTabBarView extends StatefulWidget {
  const NoticeTabBarView({Key key, this.index}) : super(key: key);
  final int index;

  @override
  _NoticeTabBarViewState createState() => _NoticeTabBarViewState();
}

class _NoticeTabBarViewState extends State<NoticeTabBarView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => NoticeListBloc(repository: context.read<HomeRepository>())
        ..add(NoticeListOnLoaded(widget.index)),
      child: BlocBuilder<NoticeListBloc, NoticeListState>(
        builder: (context, state) => state.status.when(
          context,
          builder: (context) => ListView.separated(
            itemCount: state.notices.length,
            itemBuilder: (context, index) {
              final item = state.notices[index];
              return GestureDetector(
                key: Key('${widget.index}notice_item$index'),
                behavior: HitTestBehavior.opaque,
                onTap: () => RouterUtil.toNotice(context, item.id),
                child: Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyles.text
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Gaps.vGap4,
                          Text(
                            item.content,
                            style: TextStyles.text12,
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        '2021/4/29',
                        style:
                            TextStyle(color: Colours.textGrey2, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => Divider(
              indent: 20,
              color: Colours.textGrey2.withAlpha(30),
              endIndent: 20,
              height: 0.1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
