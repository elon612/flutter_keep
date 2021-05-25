part of 'brand_bloc.dart';

enum BrandActionType {
  recommend,
  normal,
}

class BrandState extends Equatable {
  const BrandState(
      {this.recommended = BrandActionType.recommend,
      this.inGrid = true,
      this.status = PageStatus.init,
      this.brands = const <Brand>[]});

  final bool inGrid;

  final BrandActionType recommended;

  final PageStatus status;

  final List<Brand> brands;

  BrandState copyWith(
          {BrandActionType recommended,
          bool inGrid,
          PageStatus status,
          List<Brand> brands}) =>
      BrandState(
          recommended: recommended != null ? recommended : this.recommended,
          inGrid: inGrid != null ? inGrid : this.inGrid,
          status: status ?? this.status,
          brands: brands ?? this.brands);

  @override
  List<Object> get props => [recommended, inGrid, status, brands];
}
