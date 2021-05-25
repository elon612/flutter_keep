part of 'notice_list_bloc.dart';

abstract class NoticeListEvent extends Equatable {
  const NoticeListEvent();
}

class NoticeListOnLoaded extends NoticeListEvent {

  NoticeListOnLoaded(this.index);
  final int index;

  @override
  List<Object> get props => [index];
}