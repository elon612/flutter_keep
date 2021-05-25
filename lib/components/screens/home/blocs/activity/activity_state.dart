part of 'activity_bloc.dart';

class ActivityState extends Equatable {
  const ActivityState({this.status = PageStatus.init, this.result});

  final PageStatus status;
  final ActivityResult result;

  ActivityState copyWith({PageStatus status, ActivityResult result}) =>
      ActivityState(
          status: status ?? this.status, result: result ?? this.result);

  @override
  List<Object> get props => [status, result];
}
