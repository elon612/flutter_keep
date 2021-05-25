import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({Key key, this.value, this.plusOnTap, this.minusOnTap})
      : super(key: key);

  final String value;
  final void Function() plusOnTap;
  final void Function() minusOnTap;

  @override
  Widget build(BuildContext context) {
    final background = Colours.greyBackground;
    final operatorStyle = TextStyle(fontSize: 16, color: Colours.text);
    final unActiveOperatorStyle =
        operatorStyle.copyWith(color: Color(0xffcccccc));

    return Container(
      width: 81,
      height: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: minusOnTap,
              child: Container(
                width: 24,
                alignment: Alignment.center,
                color: background,
                child: Text(
                  '-',
                  style: value == '1' ? unActiveOperatorStyle : operatorStyle,
                ),
              ),
            ),
            Container(
              width: 33,
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyles.text,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: plusOnTap,
              child: Container(
                color: background,
                alignment: Alignment.center,
                width: 24,
                child: Text(
                  '+',
                  style: operatorStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
