import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/page_status.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'order_detail_event.dart';
part 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {

  OrderDetailBloc({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(OrderDetailState());

  final UserRepository _userRepository;

  @override
  Stream<OrderDetailState> mapEventToState(
    OrderDetailEvent event,
  ) async* {
    if (event is OrderDetailOnLoaded) {
      yield* _mapDetailOnLoadedToState(event);
    }
  }

  Stream<OrderDetailState> _mapDetailOnLoadedToState(
      OrderDetailOnLoaded event) async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final OrderItem item = await _userRepository.orderBy(event.orderId);
    if (item != null) {
      yield state.copyWith(status: PageStatus.success, item: item);
    }

  }
}
