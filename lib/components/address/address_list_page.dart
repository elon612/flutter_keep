import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/address/blocs/blocs.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

import 'package:flutter_keep/components/common/common.dart';

class AddressListPage extends StatelessWidget {
  const AddressListPage({Key key, this.fromSubmitting = false})
      : super(key: key);
  final bool fromSubmitting;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressListBloc>(
      create: (context) =>
          AddressListBloc(userRepository: context.read<UserRepository>())
            ..add(AddressListOnLoaded()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text('地址列表'),
          elevation: 4,
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<AddressListBloc, AddressListState>(
          builder: (context, state) => state.status.when(
            context,
            builder: (context) => SafeArea(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) {
                          final address = state.addresses[index];
                          return _AddressItemView(
                            address: address,
                            onEdit: () =>
                                RouterUtil.toAddressManage(context, address),
                            onTap: fromSubmitting
                                ? () => Navigator.pop(context, address)
                                : null,
                          );
                        },
                        itemCount: state.addresses.length,
                        separatorBuilder: (context, index) =>
                            index != state.addresses.length - 1
                                ? Divider()
                                : Container(),
                      ),
                    ),
                    Gaps.vGap4,
                    _AddressListButton(),
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

class _AddressListButton extends StatelessWidget {
  const _AddressListButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      margin: EdgeInsets.all(12),
      child: TextButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
            Gaps.hGap4,
            Text(
              '新建收货地址',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onPressed: () => RouterUtil.toAddressManage(context, null),
      ),
    );
  }
}

class _AddressItemView extends StatelessWidget {
  const _AddressItemView({Key key, this.address, this.onEdit, this.onTap})
      : super(key: key);
  final Address address;
  final void Function() onEdit;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Widget tag = address.isCheck == '1'
        ? Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
            padding: EdgeInsets.all(1),
            child: Text(
              '默认',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          )
        : Container();

    final headerStyle = TextStyle(color: Colors.grey);
    final bottomStyle = headerStyle;

    Widget bottom = Row(
      children: [
        Text(
          address.consignee,
          style: bottomStyle,
        ),
        SizedBox(
          width: 24,
        ),
        Text(
          address.mobile,
          style: bottomStyle,
        ),
      ],
    );

    Widget detail = Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        address.address,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    Widget header = Row(
      children: [
        tag,
        Gaps.hGap4,
        Text(
          '${address.provinceName}${address.cityName}${address.countyName}',
          style: headerStyle,
        ),
      ],
    );

    Widget content = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          detail,
          bottom,
        ],
      ),
    );

    Widget edit = GestureDetector(
      onTap: onEdit,
      child: Icon(Icons.edit),
    );

    Widget body = Row(
      children: [
        content,
        edit,
      ],
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: body,
      ),
    );
  }
}
