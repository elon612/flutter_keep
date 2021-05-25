part of 'activity_bloc.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();
}

class ActivityOnLoaded extends ActivityEvent {
  @override
  List<Object> get props => [];
}
