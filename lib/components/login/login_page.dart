import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:formz/formz.dart';
import 'package:oktoast/oktoast.dart';

import 'bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  final FocusNode _nameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        repository: context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: true,
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.formStatus == FormzStatus.submissionFailure) {
              showToast(state.errorMessage);
            } else if (state.formStatus == FormzStatus.submissionSuccess) {
              Navigator.pop(context);
            }
          },
          child: Container(
            color: Colors.white,
            height: double.maxFinite,
            child: CustomKeyboardWrapper(
              keyboardConfig: buildKeyboardActionsConfig(context, [
                _nameNode,
                _passwordNode,
              ]),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: CloseButton(
                        color: Colors.black,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    _LoginContentView(
                      nameNode: _nameNode,
                      passwordNode: _passwordNode,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginContentView extends StatefulWidget {
  const _LoginContentView({Key key, this.nameNode, this.passwordNode})
      : super(key: key);

  final FocusNode nameNode;
  final FocusNode passwordNode;

  @override
  __LoginContentViewState createState() => __LoginContentViewState();
}

class __LoginContentViewState extends State<_LoginContentView> {
  TapGestureRecognizer _tap;

  @override
  void initState() {
    _tap = TapGestureRecognizer();
    _tap.onTap = _handleOnTap;
    super.initState();
  }

  void _handleOnTap() => RouterUtil.toRegister(context);

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colours.text,
        height: 1.42);

    final registerStyle = TextStyle(
      color: Color(0xffcccccc),
      height: 1.375,
    );

    final headStyle = TextStyle(
      color: Color(0xffd9d9d9),
      fontSize: 16,
      height: 1.375,
    );

    Widget title = Text(
      '账号密码登陆',
      style: titleStyle,
    );

    Widget register = Text.rich(TextSpan(
      text: '没有账户？',
      style: registerStyle,
      children: [
        TextSpan(
          text: '注册账号',
          style: registerStyle.copyWith(
            color: Colours.text,
          ),
          recognizer: _tap,
        )
      ],
    ));

    final hintStyle =
        TextStyle(color: Color(0xffb3b3b3), fontSize: 20, height: 1.4);
    final textFiledColor = Color(0xfffafafa);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          Gaps.vGap4,
          register,
          SizedBox(
            height: 31,
          ),
          _NameTextFiled(
            node: widget.nameNode,
            headStyle: headStyle,
            hintStyle: hintStyle,
            borderColor: textFiledColor,
          ),
          Gaps.vGap20,
          _PasswordTextFiled(
            node: widget.passwordNode,
            headStyle: headStyle,
            hintStyle: hintStyle,
            borderColor: textFiledColor,
          ),
          SizedBox(
            height: 48,
          ),
          _LoginBtn(),
          Gaps.vGap16,
          // _RegisterBtn(),
        ],
      ),
    );
  }
}

class _NameTextFiled extends StatelessWidget {
  const _NameTextFiled(
      {Key key, this.node, this.headStyle, this.hintStyle, this.borderColor})
      : super(key: key);

  final FocusNode node;

  final TextStyle headStyle;

  final TextStyle hintStyle;

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用户名',
                  style: headStyle,
                ),
                TextField(
                  enabled: state.formStatus != FormzStatus.submissionInProgress,
                  focusNode: node,
                  cursorColor: borderColor,
                  style: hintStyle.copyWith(color: Colours.text),
                  decoration: InputDecoration(
                      hintText: '请输入账号信息',
                      errorText: state.username.invalid ? '账号不能为空' : null,
                      hintStyle: hintStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: borderColor),
                      )),
                  onChanged: (v) =>
                      context.read<LoginBloc>().add(UserNameOnChanged(v)),
                  textInputAction: TextInputAction.next,
                ),
              ],
            ));
  }
}

class _PasswordTextFiled extends StatelessWidget {
  const _PasswordTextFiled(
      {Key key, this.node, this.headStyle, this.hintStyle, this.borderColor})
      : super(key: key);

  final FocusNode node;

  final TextStyle headStyle;

  final TextStyle hintStyle;

  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '密码',
                  style: headStyle,
                ),
                TextField(
                  enabled: state.formStatus != FormzStatus.submissionInProgress,
                  focusNode: node,
                  obscureText: true,
                  cursorColor: borderColor,
                  style: hintStyle.copyWith(color: Colours.text),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderColor),
                    ),
                    hintText: '请输入密码',
                    hintStyle: hintStyle,
                    errorText: state.password.invalid ? '密码不能为空' : null,
                  ),
                  onChanged: (v) =>
                      context.read<LoginBloc>().add(PasswordOnChanged(v)),
                )
              ],
            ));
  }
}

class _LoginBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(double.maxFinite, 44)),
          backgroundColor: MaterialStateProperty.all(Colours.text),
        ),
        child: Text(
          '登陆',
          style: TextStyle(color: Colors.white, fontSize: 16, height: 1.375),
        ),
        onPressed: () => context.read<LoginBloc>().add(LoginFormSubmitted()),
      ),
    );
  }
}

// class _RegisterBtn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextStyle registerStyle =
//         TextStyle(color: Colours.text, height: 1.375, fontSize: 16);
//     return Row(
//       children: [
//         // Text('点击按钮表示同意《xxx协议》', style: TextStyle(
//         //   fontSize: 12,
//         //   color: Colours.textGrey,
//         //   height: 1.41,
//         // ),),
//         Spacer(),
//         GestureDetector(
//             onTap: () => {},
//             child: Text(
//               '账号注册',
//               style: registerStyle,
//             )),
//       ],
//     );
//   }
// }
