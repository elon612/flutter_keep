import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({Key key, this.onPressed, this.text, this.color})
      : super(key: key);

  final String text;

  final void Function() onPressed;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
      style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size(88, 32)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              side: BorderSide(color: color),
              borderRadius: BorderRadius.circular(12)))),
    );
  }
}
