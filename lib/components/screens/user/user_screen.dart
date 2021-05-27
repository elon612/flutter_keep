import 'package:flutter/material.dart';
import 'package:flutter_keep/components/screens/user/views/views.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:flutter_keep/utils/utils.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _precacheImages() {
    [
      R.assets.mineOrder,
      R.assets.mineAddress,
      R.assets.mineOrderMessage,
      R.assets.mineFeedback,
      R.assets.mineContact,
      R.assets.mineSetting
    ].map((e) => precacheImage(e, context)).toList();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MediaQuery.removePadding(
        context: context,
        child: Container(
          color: Colours.greyBackground,
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserAvatar(),
                Gaps.vGap20,
                _UserItemView(
                  icon: R.assets.mineOrder.image(),
                  text: '我的订单',
                  onTap: () => RouterUtil.toOrderList(context),
                ),
                Gaps.vGap4,
                _UserItemView(
                  icon: R.assets.mineAddress.image(),
                  text: '地址管理',
                  onTap: () => RouterUtil.toAddressList(context),
                ),
                Gaps.vGap4,
                _UserItemView(
                  icon: R.assets.mineOrderMessage.image(),
                  text: '网站公告',
                  onTap: () => RouterUtil.toNoticeList(context),
                ),
                Gaps.vGap16,
                // _UserItemView(
                //   icon: R.assets.mineFeedback.image(),
                //   text: '问题反馈',
                //   onTap: () => RouterUtil.toFeedback(context),
                // ),
                Gaps.vGap4,
                _UserItemView(
                  icon: R.assets.mineContact.image(),
                  text: '联系我们',
                  onTap: () => Utils.launchTel('10086').catchError((e) =>
                      showSnackBar(context, content: Text(e.toString()))),
                ),
                Gaps.vGap4,
                _UserItemView(
                  icon: R.assets.mineSetting.image(),
                  text: '设置',
                  onTap: () => RouterUtil.toSettings(context),
                ),
              ],
            ),
          ),
        ));
  }
}

class _UserItemView extends StatelessWidget {
  const _UserItemView({Key key, this.icon, this.text, this.onTap})
      : super(key: key);

  final Widget icon;

  final String text;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyles.text.copyWith(fontWeight: FontWeight.bold);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Gaps.hGap20,
            icon ?? Gaps.empty,
            Gaps.hGap16,
            Text(
              text,
              style: textStyle,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_sharp,
              color: Color(0xffb3b3b3),
              size: 14,
            ),
            SizedBox(
              width: 11,
            ),
          ],
        ),
      ),
    );
  }
}
