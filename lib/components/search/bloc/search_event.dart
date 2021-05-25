part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchOnLoaded extends SearchEvent {

  @override
  List<Object> get props => [];
}

class SearchValueOnChanged extends SearchEvent {
  SearchValueOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class SearchValueOnSubmitted extends SearchEvent {
  SearchValueOnSubmitted(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class SearchValueMoreOnLoaded extends SearchEvent {
  @override
  List<Object> get props => [];
}

class SearchHistoryTagOnClicked extends SearchEvent {

  SearchHistoryTagOnClicked(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class SearchHistoryOnDeleted extends SearchEvent {

  @override
  List<Object> get props => [];
}