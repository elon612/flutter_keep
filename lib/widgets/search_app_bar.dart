import 'package:flutter/material.dart';
import 'package:flutter_keep/constants/constants.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar(
      {Key key,
      this.onTap,
      this.hintText = '',
      this.circularBorder = 24.0,
      this.enabled = false,
      this.controller,
      this.onSubmitted,
      this.focusNode,
      this.color = const Color.fromARGB(255, 237, 236, 237),
      this.height,
      this.onChanged,
      this.textStyle,
      this.hintStyle})
      : super(key: key);

  final Color color;

  final void Function() onTap;

  final String hintText;

  final TextStyle textStyle;

  final TextStyle hintStyle;

  final double circularBorder;

  final bool enabled;

  final TextEditingController controller;

  final void Function(String value) onSubmitted;

  final FocusNode focusNode;

  final double height;

  final ValueChanged<String> onChanged;

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ??
        TextStyle(color: Colours.textGrey, fontSize: 16, height: 1.6);

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.maxFinite,
        height: widget.height ?? 37,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.circularBorder)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: R.assets.homeSearch.image(),
            ),
            if (widget.enabled)
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    focusNode: widget.focusNode,
                    controller: _controller,
                    enabled: widget.enabled,
                    onSubmitted: widget.onSubmitted,
                    onChanged: widget.onChanged,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                    ),
                    cursorColor: Color.fromARGB(255, 0, 189, 96),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: widget.hintStyle ?? textStyle,
                      contentPadding: const EdgeInsets.only(top: 0.0, left: -2, right: 16.0, bottom: 10.0),
                    ),
                  ),
                ),
              )
            else
              Text(
                widget.hintText,
                style: textStyle,
              ),
          ],
        ),
      ),
    );
  }
}
