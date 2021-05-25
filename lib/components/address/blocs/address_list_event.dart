part of 'address_list_bloc.dart';

abstract class AddressListEvent extends Equatable {
  const AddressListEvent();
}

class AddressListOnLoaded extends AddressListEvent {

  @override
  List<Object> get props => [];
}