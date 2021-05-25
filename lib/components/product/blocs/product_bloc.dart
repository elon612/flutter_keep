import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(
      {ProductRepository repository,
      UserRepository userRepository,
      AuthenticationBloc bloc})
      : assert(repository != null),
        assert(userRepository != null),
        _repository = repository,
        _userRepository = userRepository,
        super(ProductState(authStatus: bloc.state.status)) {
    _streamSubscription = bloc.stream.listen((event) {
      add(AuthenticationStatusOnChanged(event.status));
    });
  }

  final UserRepository _userRepository;
  final ProductRepository _repository;

  StreamSubscription _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is ProductOnLoaded) {
      yield* _mapProductOnLoadedToState(event);
    } else if (event is ProductCollectionOnClicked) {
      yield* _mapCollectionOnClickedToState();
    } else if (event is AuthenticationStatusOnChanged) {
      yield state.copyWith(authStatus: event.status);
    }
  }

  Stream<ProductState> _mapCollectionOnClickedToState() async* {
    if (state.authStatus != AuthenticationStatus.authenticated) {
      yield* state.copyErrorWithReset(ProductError.noAuth);
    } else {
      final bool value = !state.collected;
      final String productId = state.productId;
      if (value) {
        await _userRepository.collected(productId);
      } else {
        await _userRepository.uncollected(productId);
      }
      yield state.copyWith(collected: value);
    }
  }

  Stream<ProductState> _mapProductOnLoadedToState(
      ProductOnLoaded event) async* {
    final String productId = event.productId;
    yield state.copyWith(status: PageStatus.inProcess);
    final info = await _repository.getProductDetailInfo();
    final collected = _userRepository.inCollection(productId);
    yield state.copyWith(
        status: PageStatus.success,
        collected: collected,
        productId: productId,
        detailInfo: info);
  }
}
