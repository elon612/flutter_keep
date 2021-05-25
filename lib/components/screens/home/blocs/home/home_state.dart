part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({this.status = PageStatus.init, this.notices = const []});

  final PageStatus status;
  final List<Notice> notices;

  HomeState copyWith({PageStatus status, List<Notice> notices}) => HomeState(
      status: status ?? this.status, notices: notices ?? this.notices);

  @override
  List<Object> get props => [status, notices];
}
