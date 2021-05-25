part of 'address_manage_bloc.dart';

abstract class AddressManageEvent extends Equatable {
  const AddressManageEvent();
}

class AddressManageOnLoaded extends AddressManageEvent {
  AddressManageOnLoaded(this.address);
  final Address address;

  @override
  List<Object> get props => [address];
}

class AddresseeOnChanged extends AddressManageEvent {
  AddresseeOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class ContactOnChanged extends AddressManageEvent {
  ContactOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class DistrictOnChanged extends AddressManageEvent {
  DistrictOnChanged(this.value, this.regionIds);
  final String value;
  final List<String> regionIds;

  @override
  List<Object> get props => [value, regionIds];
}

class AddressOnChanged extends AddressManageEvent {
  AddressOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class DefaultOnSwitched extends AddressManageEvent {
  DefaultOnSwitched(this.value);
  final bool value;

  @override
  List<Object> get props => [value];
}

class AddressManageOnDeleted extends AddressManageEvent {
  @override
  List<Object> get props => [];
}

class AddressManageOnSubmitted extends AddressManageEvent {
  @override
  List<Object> get props => [];
}
