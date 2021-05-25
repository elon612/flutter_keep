part of 'brand_bloc.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();
}

class BrandOnLoaded extends BrandEvent {
  @override
  List<Object> get props => [];
}

class BrandOrderOnChanged extends BrandEvent {

  BrandOrderOnChanged(this.type);
  final BrandActionType type;

  @override
  List<Object> get props => [type];
}

class BrandLayoutOnChanged extends BrandEvent {

  @override
  List<Object> get props => [];
}