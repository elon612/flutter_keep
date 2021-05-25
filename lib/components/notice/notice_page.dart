import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/notice/blocs/blocs.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/widgets/widgets.dart';

import 'package:flutter_keep/components/common/common.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({Key key, this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('公告详情'),
      ),
      body: BlocProvider(
        create: (_) => NoticeCubit(
          id: id,
          repository: context.read<HomeRepository>(),
        ),
        child: BlocBuilder<NoticeCubit, NoticeState>(
          builder: (context, state) => state.status.when(
            context,
            builder: (context) => state.notice.type == 2
                ? FadeInImage(
                    image: state.notice.pic != null
                        ? R.json.images.banner1
                        : R.assets.noticeExampleImage, // 随便找的
                    fit: BoxFit.cover,
                    placeholder: R.assets.imagePlaceholder,
                  )
                : Center(
                    child: Text(state.notice.content),
                  ),
          ),
        ),
      ),
    );
  }
}
