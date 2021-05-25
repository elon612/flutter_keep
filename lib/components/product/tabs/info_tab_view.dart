import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/widgets/widgets.dart';

const double _kBorderWidth = 0.5;
const Color _kBorderColor = Color(0xfffafafa);

class InfoTabView extends StatelessWidget {
  const InfoTabView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TableBorder border =
        TableBorder.all(color: _kBorderColor, width: _kBorderWidth);
    final contentPadding = EdgeInsets.only(left: 8);

    Map<int, TableColumnWidth> columnWidths = {
      0: FractionColumnWidth(0.3),
      1: FractionColumnWidth(0.7),
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 28),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _HeaderRow(
              text: '商品信息',
            ),
            Table(
              border: border,
              columnWidths: columnWidths,
              children: [
                TableRow(children: [
                  _TextCell(
                    text: '韩网名称',
                  ),
                  _TextCell(
                    text: '[Dearest] Canele (nb) -네이비',
                    alignment: Alignment.centerLeft,
                    padding: contentPadding,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '商品编号',
                  ),
                  _TextCell(
                    text: '악녀일기-301778587',
                    alignment: Alignment.centerLeft,
                    padding: contentPadding,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '商品描述',
                  ),
                  _TextCell(
                    text: '修身 时尚 中长款',
                    alignment: Alignment.centerLeft,
                    padding: contentPadding,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '商品材质',
                  ),
                  _TextCell(
                    text: '涤纶91% 氨纶9%',
                    alignment: Alignment.centerLeft,
                    padding: contentPadding,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '产地',
                  ),
                  _TextCell(
                    text: '韩国',
                    alignment: Alignment.centerLeft,
                    padding: contentPadding,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '详情',
                  ),
                  _TextCell(
                    height: 150,
                    text: """
由于测量方法不同,尺寸数据可能存在单面1~3cm误差；
由于电脑显示器的分辨率不同可能出现一些色差；
实际颜色与细节图片相似，请参考图片；
洗涤方式：建议手洗，干洗。
                   """,
                    alignment: Alignment.centerLeft,
                    padding: contentPadding,
                  ),
                ]),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            _HeaderRow(
              text: '商品尺寸',
            ),
            Table(
              border: border,
              columnWidths: {
                0: FractionColumnWidth(0.3),
                1: FractionColumnWidth(0.233),
                2: FractionColumnWidth(0.233),
                3: FractionColumnWidth(0.233),
              },
              children: [
                TableRow(children: [
                  _TextCell(
                    text: '尺寸',
                  ),
                  _TextCell(
                    text: 'S',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: 'M',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: 'L',
                    alignment: Alignment.center,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '总长',
                  ),
                  _TextCell(
                    text: '61',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: '61',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: '61',
                    alignment: Alignment.center,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '腰宽',
                  ),
                  _TextCell(
                    text: '33',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: '35.5',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: '38',
                    alignment: Alignment.center,
                  ),
                ]),
                TableRow(children: [
                  _TextCell(
                    text: '臀宽',
                  ),
                  _TextCell(
                    text: '42.5',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: '45',
                    alignment: Alignment.center,
                  ),
                  _TextCell(
                    text: '47.5',
                    alignment: Alignment.center,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TextCell extends StatelessWidget {
  const _TextCell(
      {Key key,
      this.text,
      this.alignment = Alignment.center,
      this.height = 38,
      this.padding = EdgeInsets.zero})
      : super(key: key);

  final String text;
  final AlignmentGeometry alignment;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          height: height,
          padding: padding,
          alignment: alignment,
          child: Text(
            text,
            style: TextStyles.text12.copyWith(color: Colours.textGrey2),
          ),
        ));
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({Key key, this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    BorderSide side = BorderSide(color: _kBorderColor, width: _kBorderWidth);
    return Row(
      children: [
        Flexible(
          child: Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(top: side, left: side, right: side),
            ),
            child: Text(
              text,
              style: TextStyles.text12.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          flex: 3,
        ),
        Flexible(
          flex: 7,
          child: Gaps.empty,
        ),
      ],
    );
  }
}
