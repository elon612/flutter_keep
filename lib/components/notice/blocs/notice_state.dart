part of 'notice_cubit.dart';

class NoticeState extends Equatable {
  const NoticeState({this.status = PageStatus.init, this.notice});

  final PageStatus status;

  final Notice notice;

  NoticeState copyWith({PageStatus status, Notice notice}) =>
      NoticeState(status: status ?? this.status, notice: notice ?? this.notice);

  @override
  List<Object> get props => [status, notice];
}
