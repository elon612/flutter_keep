import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/components/search/bloc/search_bloc.dart';
import 'package:flutter_keep/constants/constants.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:flutter_keep/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  RefreshController _controller;
  TextEditingController _editingController;

  @override
  void initState() {
    _controller = RefreshController();
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 联想
  Widget _buildSuggestionWidget() {
    return Container(
      color: Colors.white,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '搜索历史',
                style: TextStyles.title,
              ),
              Spacer(),
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () =>
                      context.read<SearchBloc>().add(SearchHistoryOnDeleted()),
                ),
              ),
            ],
          ),
          Gaps.vGap16,
          BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) => Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: state.histories
                      .map(
                        (e) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context
                              .read<SearchBloc>()
                              .add(SearchHistoryTagOnClicked(e)),
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 24, top: 4, right: 24, bottom: 4),
                            decoration: BoxDecoration(
                                color: Colours.greyBackground,
                                borderRadius: BorderRadius.circular(16.0)),
                            child: Text(
                              e,
                              style: TextStyles.text.copyWith(
                                height: 1.375,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(
        repository: context.read<ProductRepository>(),
        controller: _controller,
      )..add(SearchOnLoaded()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: BlocListener<SearchBloc, SearchState>(
            listenWhen: (pre, next) => _editingController.text != next.value,
            listener: (context, state) {
              _editingController.text = state.value;
              _editingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _editingController.text.length));
            },
            child: Builder(
              builder: (context) => SearchAppBar(
                key: const Key('search_bar'),
                enabled: true,
                height: 32,
                hintStyle: TextStyle(height: 1, color: Colours.textGrey),
                hintText: '搜索商品编号或商品ID',
                controller: _editingController,
                onChanged: (v) =>
                    context.read<SearchBloc>().add(SearchValueOnChanged(v)),
                onSubmitted: (v) =>
                    context.read<SearchBloc>().add(SearchValueOnSubmitted(v)),
              ),
            ),
          ),
          actions: [
            CupertinoButton(
              key: const Key('search_back_Button'),
              child: Text(
                '取消',
                style: TextStyles.text,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.empty:
                return _buildSuggestionWidget();
              case SearchStatus.ResultEmpty:
                return Center(
                  child: Text('没有匹配的商品'),
                );
              case SearchStatus.valid:
                return SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  controller: _controller,
                  onLoading: () => context.read<SearchBloc>()
                    ..add(SearchValueMoreOnLoaded()),
                  child: state.result.isEmpty
                      ? Container()
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          gridDelegate: ProductItemWidget.withGridDelegate(),
                          itemBuilder: (context, index) {
                            final item = state.result[index];
                            return ProductItemWidget(
                              key: Key('search_product_item$index'),
                              product: item,
                            );
                          },
                          itemCount: state.result.length,
                        ),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
