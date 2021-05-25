import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/notice.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'notice_list_event.dart';
part 'notice_list_state.dart';

class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  NoticeListBloc({HomeRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(NoticeListState());

  final HomeRepository _repository;

  @override
  Stream<NoticeListState> mapEventToState(
    NoticeListEvent event,
  ) async* {
    if (event is NoticeListOnLoaded) {
      yield* _mapListOnLoadedToState(event);
    }
  }

  Stream<NoticeListState> _mapListOnLoadedToState(
      NoticeListOnLoaded event) async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final data = await _repository.getNoticesBy(event.index);
    yield state.copyWith(status: PageStatus.success, notices: data);
  }
}
