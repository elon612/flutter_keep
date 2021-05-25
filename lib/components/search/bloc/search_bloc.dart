import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({ProductRepository repository, RefreshController controller})
      : assert(repository != null),
        assert(controller != null),
        _repository = repository,
        _controller = controller,
        super(SearchState());

  final ProductRepository _repository;
  final RefreshController _controller;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchValueOnChanged) {
      yield* _mapValueOnChangedToState(event);
    } else if (event is SearchValueOnSubmitted) {
      yield* _mapValueOnSubmitted(event);
    } else if (event is SearchValueMoreOnLoaded) {
      yield* _mapValueMoreOnLoadedToState();
    } else if (event is SearchHistoryTagOnClicked) {
      yield* _mapHistoryTagOnClicked(event);
    } else if (event is SearchOnLoaded) {
      yield state.copyWith(histories: _repository.getSearchTags());
    } else if (event is SearchHistoryOnDeleted) {
      yield* _mapHistoryOnDeleted();
    }
  }

  Stream<SearchState> _mapHistoryOnDeleted() async* {
    await _repository.cleanSearchHistory();
    yield state.copyWith(histories: const <String>[]);
  }

  Stream<SearchState> _mapHistoryTagOnClicked(
      SearchHistoryTagOnClicked event) async* {
    final value = event.value;
    final histories = [value, ...(state.histories.where((e) => e != value))];
    await _repository.saveSearchHistories(histories);
    yield state.copyWith(histories: histories, value: value);
    add(SearchValueOnSubmitted(value));
  }

  Stream<SearchState> _mapValueMoreOnLoadedToState() async* {
    final result = await _repository.getProductsByQuery(state.value);
    yield state.copyWith(result: [...state.result, ...result]);
    _controller.loadComplete();
  }

  Stream<SearchState> _mapValueOnChangedToState(
      SearchValueOnChanged event) async* {
    final value = event.value;
    if (event.value.isEmpty) {
      yield state.copyWith(
          status: SearchStatus.empty, result: const <Product>[], value: value);
    } else {
      yield state.copyWith(value: value, status: SearchStatus.valid);
    }
  }

  Stream<SearchState> _mapValueOnSubmitted(
      SearchValueOnSubmitted event) async* {
    final value = event.value;
    final histories = [value, ...(state.histories.where((e) => e != value))];
    await _repository.saveSearchHistories(histories);
    final result = await _repository.getProductsByQuery(value);
    if (result.isEmpty) {
      yield state.copyWith(
          status: SearchStatus.ResultEmpty, histories: histories);
    } else {
      yield state.copyWith(
          status: SearchStatus.valid, result: result, histories: histories);
    }
  }
}
