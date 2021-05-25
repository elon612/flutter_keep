import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({HomeScreenRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(ActivityState());

  final HomeScreenRepository _repository;

  @override
  Stream<ActivityState> mapEventToState(
    ActivityEvent event,
  ) async* {
    if (event is ActivityOnLoaded) {
      yield* _mapActivityOnLoadedToState();
    }
  }

  Stream<ActivityState> _mapActivityOnLoadedToState() async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final result = await _repository.getActivityInfo();
    yield state.copyWith(status: PageStatus.success, result: result);
  }
}
