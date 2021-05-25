import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/models/models.dart';

class OrderAddressView extends StatelessWidget {
  const OrderAddressView({Key key, this.address, this.onTap}) : super(key: key);

  final Address address;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle =
        TextStyles.text.copyWith(fontWeight: FontWeight.bold, height: 1.375);
    Widget child;
    if (address != null) {
      child = _AddressInfoView(
        address: address,
        textStyle: textStyle,
      );
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text(
              '手动添加收货地址',
              style: textStyle,
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 88,
        padding:
            const EdgeInsets.only(left: 14, right: 19, top: 13, bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined),
            SizedBox(
              width: 19,
            ),
            Expanded(
              child: child,
            ),
            SizedBox(
              width: 22,
            ),
            Icon(
              Icons.arrow_forward_ios_sharp,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressInfoView extends StatelessWidget {
  const _AddressInfoView({Key key, this.address, this.textStyle})
      : super(key: key);
  final Address address;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final TextStyle addressStyle =
        TextStyles.text.copyWith(fontSize: 12, height: 1.416);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              address.consignee,
              style: textStyle,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              address.mobile,
              style: textStyle,
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          address.address,
          style: addressStyle,
        ),
      ],
    );
  }
}
