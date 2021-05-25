import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/page_status.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListBloc(
      {UserRepository userRepository, RefreshController refreshController})
      : assert(userRepository != null),
        assert(refreshController != null),
        _userRepository = userRepository,
        _refreshController = refreshController,
        super(OrderListState()) {
    _streamSubscription = _userRepository.orderStream.listen((_) {
      add(OrderListOnLoaded(state.type));
    });
  }

  final UserRepository _userRepository;
  final RefreshController _refreshController;

  StreamSubscription<void> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<OrderListState> mapEventToState(
    OrderListEvent event,
  ) async* {
    if (event is OrderListOnLoaded) {
      yield* _mapListOnLoadedToState(event);
    } else if (event is OrderListOnPulled) {
      yield* _mapListOnPulledToState();
    } else if (event is OrderListOnCanceled) {
      yield* _mapListOnCanceledToState(event);
    }
  }

  Stream<OrderListState> _mapListOnCanceledToState(
      OrderListOnCanceled event) async* {
    await _userRepository.orderCancel(event.item.orderId);
  }

  Stream<OrderListState> _mapListOnPulledToState() async* {
  }

  Stream<OrderListState> _mapListOnLoadedToState(
      OrderListOnLoaded event) async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final List<OrderItem> items = await _userRepository.ordersBy(event.type);
    if (items.length < 20) _refreshController.loadNoData();
    yield state.copyWith(
        status: PageStatus.success, items: items, type: state.type);
  }
}
