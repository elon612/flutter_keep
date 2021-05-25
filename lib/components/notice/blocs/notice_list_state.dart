part of 'notice_list_bloc.dart';

class NoticeListState extends Equatable {
  const NoticeListState(
      {this.status = PageStatus.init, this.notices = const <Notice>[]});

  final PageStatus status;
  final List<Notice> notices;

  NoticeListState copyWith({PageStatus status, List<Notice> notices}) =>
      NoticeListState(
          status: status ?? this.status, notices: notices ?? this.notices);

  @override
  List<Object> get props => [status, notices];
}
