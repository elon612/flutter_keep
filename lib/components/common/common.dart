import 'package:flutter/material.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'page_status.dart';

export 'product_item_widget.dart';
export 'product_list_widget.dart';
export 'page_status.dart';
export 'sliver_header_delegate.dart';

ButtonStyle get defaultButtonStyle => ButtonStyle(
      minimumSize: MaterialStateProperty.all(
        Size(88, 32),
      ),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

extension PageStatusExtension on PageStatus {
  Widget when(BuildContext context, {Widget builder(BuildContext context)}) {
    switch (this) {
      case PageStatus.init:
        return Container();
      case PageStatus.inProcess:
        return CustomStateWidget(type: StateType.loading);
      case PageStatus.success:
        return Builder(
          builder: builder,
        );
      case PageStatus.failure:
        return CustomStateWidget(type: StateType.network);
    }
    return Container();
  }
}
