part of 'other_bloc.dart';

abstract class OtherEvent extends Equatable {
  const OtherEvent();
}

class OtherOnLoaded extends OtherEvent {
  final int index;

  OtherOnLoaded(this.index);

  @override
  List<Object> get props => [];
}

class OtherMoreOnLoaded extends OtherEvent {
  OtherMoreOnLoaded(this.index);

  final int index;

  @override
  List<Object> get props => [];
}
