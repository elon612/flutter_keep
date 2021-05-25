import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(HomeState());

  final HomeRepository _repository;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeOnLoaded) {
      yield* _mapHomeOnLoadedToState();
    }
  }

  Stream<HomeState> _mapHomeOnLoadedToState() async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final data = await _repository.getNotices();
    yield state.copyWith(status: PageStatus.success, notices: data);
  }
}
