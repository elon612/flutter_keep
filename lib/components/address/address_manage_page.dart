import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/address/blocs/blocs.dart';
import 'package:flutter_keep/components/register/formz/formz.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:formz/formz.dart';
import 'package:oktoast/oktoast.dart';

import 'views/views.dart';

class AddressManagePage extends StatelessWidget {
  AddressManagePage({Key key, this.address}) : super(key: key);
  final Address address;

  final FocusNode _addresseeNode = FocusNode();
  final FocusNode _mobileNode = FocusNode();
  final FocusNode _addressNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressManageBloc>(
      create: (context) => AddressManageBloc(
        userRepository: context.read<UserRepository>(),
      )..add(AddressManageOnLoaded(address)),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(address != null ? '编辑地址' : '添加地址'),
          elevation: 4,
          backgroundColor: Colors.white,
          actions: [
            address != null
                ? Builder(
                    builder: (context) => TextButton(
                      onPressed: () => _showDialog(context),
                      child: Text(
                        '删除',
                        style: TextStyles.text,
                      ),
                    ),
                  )
                : Gaps.empty,
          ],
        ),
        body: BlocListener<AddressManageBloc, AddressManageState>(
          listener: (context, state) {
            if (state.status == FormzStatus.submissionSuccess) {
              showToast(address != null ? '编辑成功' : '添加成功');
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomKeyboardWrapper(
                  keyboardConfig: buildKeyboardActionsConfig(context, [
                    _addresseeNode,
                    _mobileNode,
                    _addressNode,
                  ]),
                  child: _AddressFormView(
                    addresseeNode: _addresseeNode,
                    mobileNode: _mobileNode,
                    addressNode: _addressNode,
                  ),
                ),
              ),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('确认删除改地址嘛？'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('取消')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('确认')),
            ],
          );
        });
    if (result != null) {
      context.read<AddressManageBloc>().add(AddressManageOnDeleted());
    }
  }
}

class _AddressFormView extends StatelessWidget {
  final FocusNode addresseeNode;
  final FocusNode mobileNode;
  final FocusNode addressNode;

  const _AddressFormView(
      {Key key, this.addresseeNode, this.mobileNode, this.addressNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      height: 1,
    );
    final padding = EdgeInsets.symmetric(horizontal: 16);
    final boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    );

    Widget formList = Container(
      padding: padding,
      decoration: boxDecoration,
      child: Column(
        children: [
          _AddresseeTextInput(
            focusNode: addresseeNode,
          ),
          divider,
          _ContactTextInput(
            focusNode: mobileNode,
          ),
          divider,
          _DistrictTextInput(),
          divider,
          _AddressTextInput(
            focusNode: addressNode,
          ),
        ],
      ),
    );

    Widget hasDefault = Container(
      padding: padding,
      decoration: boxDecoration,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Text('设置为默认'),
        trailing: BlocBuilder<AddressManageBloc, AddressManageState>(
          builder: (context, state) => CupertinoSwitch(
            value: state.hasDefault,
            onChanged: (v) =>
                context.read<AddressManageBloc>().add(DefaultOnSwitched(v)),
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          Gaps.vGap20,
          formList,
          Gaps.vGap20,
          hasDefault,
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> unActiveStates = <MaterialState>{
      MaterialState.disabled,
    };
    if (states.any(unActiveStates.contains)) {
      return Colors.grey;
    }
    return Colours.text;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(12),
        child: BlocBuilder<AddressManageBloc, AddressManageState>(
          buildWhen: (pre, cur) => pre.status != cur.status,
          builder: (context, state) => state.status.isSubmissionInProgress
              ? CircularProgressIndicator()
              : TextButton(
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => getColor(states)),
                      minimumSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 40)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ))),
                  child: Text(
                    '保存',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<AddressManageBloc>().add(
                            AddressManageOnSubmitted(),
                          )
                      : null,
                ),
        ),
      ),
    );
  }
}

class _DistrictTextInput extends StatefulWidget {
  @override
  __DistrictTextInputState createState() => __DistrictTextInputState();
}

class __DistrictTextInputState extends State<_DistrictTextInput> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void _showAddressPicker(BuildContext context) async {
    final repository = context.read<UserRepository>();
    final regions = await repository.regions();
    final result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (BuildContext context) {
          return RegionPicker(
            regions: regions,
          );
        });
    if (result != null) {
      final value = result['value'];
      final ids = result['ids'];
      context.read<AddressManageBloc>().add(DistrictOnChanged(value, ids));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressManageBloc, AddressManageState>(
      listener: (pre, next) {
        if (_controller.text != next.district.value) {
          _controller.text = next.district.value;
        }
      },
      child: _ListTileForm(
        controller: _controller,
        leading: '所在地区',
        hintText: '请选择收件人所在地区',
        enable: false,
        trail: Icon(Icons.arrow_drop_down),
        onTap: () => _showAddressPicker(context),
      ),
    );
  }
}

class _AddresseeTextInput extends StatefulWidget {
  const _AddresseeTextInput({Key key, this.focusNode}) : super(key: key);
  final FocusNode focusNode;

  @override
  __AddresseeTextInputState createState() => __AddresseeTextInputState();
}

class __AddresseeTextInputState extends State<_AddresseeTextInput> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressManageBloc, AddressManageState>(
      listener: (context, state) {
        if (_controller.text != state.addressee.value) {
          _controller.text = state.addressee.value;
        }
      },
      builder: (context, state) => _ListTileForm(
        controller: _controller,
        onChanged: (v) =>
            context.read<AddressManageBloc>().add(AddresseeOnChanged(v)),
        leading: '收件人',
        hintText: '请输入收件人姓名',
        focusNode: widget.focusNode,
        errorText: state.addressee.invalid ? '收件人不能为空' : null,
      ),
    );
  }
}

class _ContactTextInput extends StatefulWidget {
  const _ContactTextInput({Key key, this.focusNode}) : super(key: key);
  final FocusNode focusNode;

  @override
  __ContactTextInputState createState() => __ContactTextInputState();
}

class __ContactTextInputState extends State<_ContactTextInput> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressManageBloc, AddressManageState>(
        listener: (context, state) {
      if (_controller.text != state.contact.value) {
        _controller.text = state.contact.value;
      }
    }, builder: (context, state) {
      String error;
      if (state.contact.invalid) {
        if (state.contact.error == PhoneInputError.empty) {
          error = '联系方式不能为空';
        } else {
          error = '请输入合法的手机号码';
        }
      }
      return _ListTileForm(
        controller: _controller,
        onChanged: (v) =>
            context.read<AddressManageBloc>().add(ContactOnChanged(v)),
        leading: '联系方式',
        hintText: '请输入收件人联系方式',
        focusNode: widget.focusNode,
        textInputType: TextInputType.phone,
        errorText: error,
      );
    });
  }
}

class _AddressTextInput extends StatefulWidget {
  const _AddressTextInput({Key key, this.focusNode}) : super(key: key);
  final FocusNode focusNode;

  @override
  __AddressTextInputState createState() => __AddressTextInputState();
}

class __AddressTextInputState extends State<_AddressTextInput> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressManageBloc, AddressManageState>(
      listener: (context, state) {
        if (_controller.text != state.address.value) {
          _controller.text = state.address.value;
        }
      },
      builder: (context, state) => _ListTileForm(
        controller: _controller,
        onChanged: (v) =>
            context.read<AddressManageBloc>().add(AddressOnChanged(v)),
        leading: '详细地址',
        hintText: '请输入收件人所在地区具体地址（街道，门牌号等）',
        focusNode: widget.focusNode,
        maxLines: 2,
        errorText: state.address.invalid ? '详细地址不能为空' : null,
      ),
    );
  }
}

class _ListTileForm extends StatelessWidget {
  const _ListTileForm(
      {Key key,
      this.controller,
      this.leading,
      this.hintText,
      this.maxLines = 1,
      this.focusNode,
      this.enable = true,
      this.onTap,
      this.onChanged,
      this.textInputType,
      this.errorText,
      this.trail})
      : super(key: key);

  final TextEditingController controller;

  final String leading;

  final String hintText;

  final int maxLines;

  final FocusNode focusNode;

  final bool enable;

  final void Function() onTap;

  final void Function(String value) onChanged;

  final TextInputType textInputType;

  final String errorText;

  final Widget trail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 80,
              ),
              child: Text(leading),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: enable,
                focusNode: focusNode,
                maxLines: maxLines,
                onChanged: onChanged,
                style: TextStyle(fontSize: 14),
                keyboardType: textInputType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  errorText: errorText,
                ),
              ),
            ),
            trail ?? Container(),
          ],
        ),
      ),
    );
  }
}
