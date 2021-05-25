import 'package:flutter/material.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('问题反馈'),
        elevation: 4,
        backgroundColor: Colors.white,
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text('完成')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Semantics(
          multiline: true,
          maxValueLength: 150,
          child: TextField(
            maxLength: 150,
            maxLines: 5,
            autofocus: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: '请输入需要反馈的信息',
              border: InputBorder.none,
            ),
          ),
        ),
      )
    );
  }
}
