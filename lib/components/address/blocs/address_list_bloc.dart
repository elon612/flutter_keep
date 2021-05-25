import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/common/common.dart';
import 'package:flutter_keep/components/common/page_status.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'address_list_event.dart';
part 'address_list_state.dart';

class AddressListBloc extends Bloc<AddressListEvent, AddressListState> {
  AddressListBloc({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AddressListState()) {
    _streamSubscription = _userRepository.addressStream.listen((action) {
      if (action == AddressStreamAction.refresh) {
        add(AddressListOnLoaded());
      }
    });
  }

  final UserRepository _userRepository;
  StreamSubscription<void> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AddressListState> mapEventToState(
    AddressListEvent event,
  ) async* {
    if (event is AddressListOnLoaded) {
      yield* _mapListOnLoadedToState();
    }
  }

  Stream<AddressListState> _mapListOnLoadedToState() async* {
    yield state.copyWith(status: PageStatus.inProcess);
    final List<Address> addresses = await _userRepository.addresses;
    yield state.copyWith(status: PageStatus.success, addresses: addresses);
  }
}
