import 'package:flutter/material.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/components/product/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('设置'),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          Gaps.vGap20,
          _LogOutButton(),
        ],
      ),
    );
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton({Key key}) : super(key: key);

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('注销'),
        content: Text('确定要退出登录嘛？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('取消')),
          TextButton(
            onPressed: () {
              context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested());
              Navigator.pop(context);
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      switch (state.status) {
        case AuthenticationStatus.authenticated:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(
                key: const Key('settings_logout'),
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(Size(double.maxFinite, 44)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colours.text)),
                child: Text(
                  '退出登陆',
                  style: TextStyles.text.copyWith(color: Colors.white),
                ),
                onPressed: () => _showDialog(context)),
          );
        default:
          return Container();
      }
    });
  }
}
