import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/notice.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'notice_state.dart';

class NoticeCubit extends Cubit<NoticeState> {

  NoticeCubit({HomeRepository repository, int id})
      : assert(repository != null),
        _repository = repository,
        super(NoticeState()) {
    onLoaded(id: id);
  }

  HomeRepository _repository;

  void onLoaded({int id}) async {
    emit(state.copyWith(status: PageStatus.inProcess));
    final data = await _repository.getNoticeBy(id);
    emit(state.copyWith(status: PageStatus.success, notice: data));
  }
}
