import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({HomeScreenRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(CategoryState());

  final HomeScreenRepository _repository;

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is CategoryLoaded) {
      yield* _mapLoadedToState();
    }
  }

  Stream<CategoryState> _mapLoadedToState() async* {
    yield state.copyWith(status: PageStatus.inProcess);
    List<Category> categories = await _repository.getCategories();
    final keys = categories.map((e) => GlobalKey()).toList();
    yield state.copyWith(
        status: PageStatus.success, keys: keys, categories: categories);
  }
}
