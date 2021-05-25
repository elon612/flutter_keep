import 'package:flutter/material.dart';
import 'package:flutter_keep/components/components.dart';
import 'package:flutter_keep/components/screens/category/bloc/category_bloc.dart';
import 'package:flutter_keep/components/screens/category/views/views.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/routers/routers.dart';
import 'package:flutter_keep/widgets/widgets.dart';

import 'package:flutter_keep/components/common/common.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget appBar = CustomAppBar(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SearchAppBar(
          key: const Key('category_search_bar'),
          height: 32,
          hintText: '搜索',
          onTap: () => RouterUtil.toSearch(context),
        ),
      ),
    );

    return BlocProvider(
      create: (_) => CategoryBloc(
        repository: context.read<HomeScreenRepository>(),
      )..add(CategoryLoaded()),
      child: Scaffold(
        appBar: appBar,
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) => state.status.when(
            context,
            builder: (context) => CategoryContentView(
              children: state.categories,
              keys: state.keys,
              scrollController: _scrollController,
            ),
          ),
        ),
      ),
    );
  }
}
