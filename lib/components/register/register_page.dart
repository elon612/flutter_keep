import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/register/bloc/register_bloc.dart';
import 'package:flutter_keep/components/register/formz/formz.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:formz/formz.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:oktoast/oktoast.dart';

import 'ticker.dart';

extension on RegisterError {
  String message(BuildContext context) {
    switch (this) {
      case RegisterError.agreementUnUnchecked:
        return '请先勾选同意《xxx协议》';
      default:
        return '';
    }
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({Key key}) : super(key: key);

  final FocusNode _mobileNode = FocusNode();
  final FocusNode _securityNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(
          ticker: Ticker(), userRepository: context.read<UserRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.error != RegisterError.noError) {
              showToast(state.error.message(context));
            } else if (state.status == FormzStatus.submissionSuccess) {
              showToast('注册成功');
              Navigator.pop(context);
            }
          },
          child: CustomKeyboardWrapper(
            keyboardConfig: buildKeyboardActionsConfig(context, [
              _mobileNode,
              _securityNode,
              _nameNode,
              _passwordNode,
            ]),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight + data.padding.top,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: CloseButton(),
                  ),
                  Container(
                    height: 120,
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '账号注册',
                      style: TextStyles.textBold20.copyWith(fontSize: 26),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _PhoneInput(
                            node: _mobileNode,
                          ),
                          Gaps.vGap20,
                          _SecurityInput(
                            node: _securityNode,
                          ),
                          Gaps.vGap20,
                          _UserNameInput(
                            node: _nameNode,
                          ),
                          Gaps.vGap20,
                          _PasswordInput(
                            node: _passwordNode,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          _RegisterButton(),
                          SizedBox(
                            height: 22,
                          ),
                          _Agreement(),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput({Key key, this.node}) : super(key: key);
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) => _CustomTextFiled(
              node: node,
              header: '手机号',
              hintText: '请输入手机号',
              errorText: state.phone.invalid
                  ? state.phone.error.message(context)
                  : null,
              onChanged: (v) =>
                  context.read<RegisterBloc>().add(PhoneOnChanged(v)),
            ));
  }
}

class _SecurityInput extends StatelessWidget {
  const _SecurityInput({Key key, this.node}) : super(key: key);
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) => _CustomTextFiled(
              node: node,
              header: '验证码',
              hintText: '请输入验证码',
              errorText: state.security.invalid
                  ? state.security.error.message(context)
                  : null,
              onChanged: (v) =>
                  context.read<RegisterBloc>().add(SecurityOnChanged(v)),
              trail: _SecurityButton(),
            ));
  }
}

class _UserNameInput extends StatelessWidget {
  const _UserNameInput({Key key, this.node}) : super(key: key);
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) => _CustomTextFiled(
              node: node,
              header: '账号',
              hintText: '请输入用户名',
              errorText:
                  state.name.invalid ? state.name.error.message(context) : null,
              onChanged: (v) =>
                  context.read<RegisterBloc>().add(NameOnChanged(v)),
            ));
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key key, this.node}) : super(key: key);
  final FocusNode node;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) => _CustomTextFiled(
              node: node,
              header: '密码',
              hintText: '请输入登陆密码',
              errorText: state.password.invalid
                  ? state.password.error.message(context)
                  : null,
              onChanged: (v) =>
                  context.read<RegisterBloc>().add(PasswordOnChanged(v)),
            ));
  }
}

extension on PhoneInputError {
  String message(BuildContext context) => [
        '手机号不能为空',
        '请输入合法的手机号码',
      ][index];
}

extension on SecurityInputError {
  String message(BuildContext context) => [
        '验证码不能为空',
      ][index];
}

extension on NameInputError {
  String message(BuildContext context) => [
        '用户名不能为空',
      ][index];
}

extension on PasswordInputError {
  String message(BuildContext context) => [
        '密码不能为空',
      ][index];
}

class _CustomTextFiled extends StatelessWidget {
  const _CustomTextFiled(
      {Key key,
      this.header = '',
      this.onChanged,
      this.hintText,
      this.errorText,
      this.trail,
      this.node})
      : super(key: key);

  final FocusNode node;

  final String header;

  final String hintText;

  final String errorText;

  final Widget trail;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyles.textBold20;
    final TextStyle hintStyle =
        TextStyles.text.copyWith(color: Colours.textGrey3);
    final Color borderColor = Color(0xfffafafa);

    Widget textField = TextField(
      focusNode: node,
      onChanged: onChanged,
      style: textStyle,
      cursorColor: borderColor,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: hintStyle,
        border: InputBorder.none,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyles.text.copyWith(color: Colours.textGrey3),
        ),
        trail == null
            ? textField
            : Row(
                children: [
                  Expanded(child: textField),
                  Gaps.hGap16,
                  trail,
                ],
              ),
        Gaps.vGap4,
        Divider(
          color: borderColor,
          height: 0.5,
        ),
      ],
    );
  }
}

class _SecurityButton extends StatelessWidget {
  const _SecurityButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextButton(
          onPressed: () =>
              context.read<RegisterBloc>().add(SecurityButtonOnClicked()),
          child: Text(
            state.started ? '${state.securityNumber}' : '获取验证码',
            style: TextStyle(
              color: Color(0xffcccccc),
              fontSize: 12,
            ),
          ),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: Color(0xffb3b3b3),
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({Key key}) : super(key: key);

  Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return Colours.textGrey;
    }
    return Colours.text;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) => state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : TextButton(
                child: Text(
                  '注册',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      Size.fromHeight(44),
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0))),
                    backgroundColor:
                        MaterialStateProperty.resolveWith(getColor)),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<RegisterBloc>()
                        .add(RegisterButtonOnClicked())
                    : null,
              ));
  }
}

class _Agreement extends StatelessWidget {
  const _Agreement({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<RegisterBloc>().add(AgreementOnChecked()),
      child: Row(
        children: [
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) => state.agreementChecked
                ? R.assets.cartCheckActive.image()
                : R.assets.cartCheck.image(),
          ),
          Gaps.hGap4,
          Text(
            '点击按钮表示同意《xxx协议》',
            style: TextStyles.text12.copyWith(
              color: Colours.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
