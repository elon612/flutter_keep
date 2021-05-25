import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/home_screen_repository.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc({HomeScreenRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(BrandState());

  final HomeScreenRepository _repository;

  @override
  Stream<BrandState> mapEventToState(
    BrandEvent event,
  ) async* {
    if (event is BrandOnLoaded) {
      yield* _mapBrandOnLoadedToState();
    } else if (event is BrandOrderOnChanged) {
      yield* _mapOrderOnChangedToState(event);
    } else if (event is BrandLayoutOnChanged) {
      yield state.copyWith(inGrid: !state.inGrid);
    }
  }

  Stream<BrandState> _mapOrderOnChangedToState(
      BrandOrderOnChanged event) async* {
    if (event.type == state.recommended) return;
    final List<Brand> brands = state.brands.reversed.toList();
    yield state.copyWith(
        brands: brands,
        recommended: state.recommended == BrandActionType.recommend
            ? BrandActionType.normal
            : BrandActionType.recommend);
  }

  Stream<BrandState> _mapBrandOnLoadedToState() async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final List<Brand> brands = await _repository.getBrands();
    yield state.copyWith(status: PageStatus.success, brands: brands);
  }
}
