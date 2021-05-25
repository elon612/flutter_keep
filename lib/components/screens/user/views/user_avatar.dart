import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 228,
        width: double.maxFinite,
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.unknown:
              case AuthenticationStatus.unauthenticated:
                return _UnLogInAvatar(
                  onTap: () => RouterUtil.toLogin(context),
                );
              case AuthenticationStatus.authenticated:
                return _LoggedAvatar(
                  user: state.user,
                );
              default:
                return Container();
            }
          },
        ));
  }
}

class _UnLogInAvatar extends StatelessWidget {
  const _UnLogInAvatar({Key key, this.onTap}) : super(key: key);
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox.fromSize(
          size: Size.square(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: R.assets.unLoginUserAvater.image(fit: BoxFit.cover),
          ),
        ),
        Gaps.vGap16,
        TextButton(
          onPressed: onTap,
          child: Text(
            '立即登陆',
            style: TextStyles.title.copyWith(fontSize: 16),
          ),
        ),
        Gaps.vGap16,
      ],
    );
  }
}

class _LoggedAvatar extends StatelessWidget {
  const _LoggedAvatar({Key key, this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final titleStyle =
        TextStyles.title.copyWith(fontWeight: FontWeight.w800, height: 1.4);
    final nameStyle = TextStyle(color: Color(0xffb3b3b3), fontSize: 16);

    Widget name = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'XX-MALL',
          style: titleStyle,
        ),
        Gaps.vGap4,
        Text(
          '账号: ${user.userName}',
          style: nameStyle,
        ),
      ],
    );

    Widget avatar = SizedBox.fromSize(
      size: Size.square(80),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: R.json.images.productList,
      ),
    );

    Widget content = Padding(
      padding: const EdgeInsets.only(bottom: 34, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          avatar,
          Gaps.hGap20,
          name,
        ],
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        content,
      ],
    );
  }
}
