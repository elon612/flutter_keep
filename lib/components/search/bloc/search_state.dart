part of 'search_bloc.dart';

enum SearchStatus { empty, ResultEmpty, valid, error }

class SearchState extends Equatable {
  const SearchState(
      {this.page = 1,
      this.value = '',
      this.status = SearchStatus.empty,
      this.histories = const <String>[],
      this.result = const <Product>[]});

  final int page;

  final String value;

  final SearchStatus status;

  final List<String> histories;

  final List<Product> result;

  SearchState copyWith(
          {int page,
          String value,
          SearchStatus status,
          List<String> histories,
          List<Product> result}) =>
      SearchState(
          page: page ?? this.page,
          value: value ?? this.value,
          status: status ?? this.status,
          histories: histories ?? this.histories,
          result: result ?? this.result);

  @override
  List<Object> get props => [page, value, status, histories, result];
}
