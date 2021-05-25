part of 'address_list_bloc.dart';

class AddressListState extends Equatable {
  const AddressListState(
      {this.status = PageStatus.init, this.addresses = const []});
  final List<Address> addresses;
  final PageStatus status;

  AddressListState copyWith({List<Address> addresses, PageStatus status}) =>
      AddressListState(
          addresses: addresses ?? this.addresses,
          status: status ?? this.status);

  @override
  List<Object> get props => [addresses, status];
}
