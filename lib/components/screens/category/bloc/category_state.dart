part of 'category_bloc.dart';

class CategoryState extends Equatable {
  CategoryState(
      {this.status = PageStatus.init,
      this.categories = const <Category>[],
      this.keys});

  final PageStatus status;

  final List<GlobalKey> keys;

  final List<Category> categories;

  CategoryState copyWith({
    PageStatus status,
    List<GlobalKey> keys,
    List<Category> categories,
  }) {
    return CategoryState(
      status: status ?? this.status,
      keys: keys ?? this.keys,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object> get props => [status, keys, categories];
}
