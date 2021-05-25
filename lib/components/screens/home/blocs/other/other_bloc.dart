import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'other_event.dart';
part 'other_state.dart';

class OtherBloc extends Bloc<OtherEvent, OtherState> {
  OtherBloc({HomeScreenRepository repository, RefreshController controller})
      : assert(repository != null),
        assert(controller != null),
        _controller = controller,
        _repository = repository,
        super(OtherState());

  final RefreshController _controller;
  final HomeScreenRepository _repository;

  @override
  Stream<OtherState> mapEventToState(
    OtherEvent event,
  ) async* {
    if (event is OtherOnLoaded) {
      yield* _mapListOnLoaded(event);
    } else if (event is OtherMoreOnLoaded) {
      yield* _mapMoreListOnLoaded(event);
    }
  }

  Stream<OtherState> _mapListOnLoaded(OtherOnLoaded event) async* {
    yield state.copyWith(status: PageStatus.inProcess);
    List<Product> items = await _repository.getProductsBy(event.index);
    if (event.index.isOdd) items = items.reversed.toList();
    yield state.copyWith(status: PageStatus.success, products: items);
  }

  Stream<OtherState> _mapMoreListOnLoaded(OtherMoreOnLoaded event) async* {
    final page = state.page + 1;
    final items = await _repository.getProductsBy(event.index, page: page);
    if (items.isEmpty) {
      _controller.loadNoData();
    } else {
      _controller.loadComplete();
    }
    yield state.copyWith(products: [...state.products, ...items]);
  }
}
