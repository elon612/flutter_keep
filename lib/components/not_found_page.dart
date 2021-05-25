import 'package:flutter/material.dart';
import 'package:flutter_keep/widgets/widgets.dart';

class NotFoundPage extends StatelessWidget {

  const NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ROUTE WAS NOT FOUND !!!'),
          Gaps.vGap12,
          ElevatedButton(
            child: Text('Back'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    ));
  }
}
