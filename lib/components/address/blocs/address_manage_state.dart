part of 'address_manage_bloc.dart';

class AddressManageState extends Equatable {
  const AddressManageState(
      {this.status = FormzStatus.pure,
      this.addressee = const TextInput.pure(),
      this.contact = const PhoneInput.pure(),
      this.address = const TextInput.pure(),
      this.district = const TextInput.pure(),
      this.hasDefault = false,
      this.regionIds,
      this.editedAddress});

  final FormzStatus status;
  final TextInput addressee;
  final PhoneInput contact;
  final TextInput address;
  final TextInput district;
  final bool hasDefault;

  final List<String> regionIds;
  final Address editedAddress;

  List<FormzInput> get inputs => [addressee, contact, address, district];

  AddressManageState copyWith(
          {FormzStatus status,
          TextInput addressee,
          PhoneInput contact,
          TextInput district,
          TextInput address,
          bool hasDefault,
          List<String> regionIds,
          Address editedAddress}) =>
      AddressManageState(
        status: status ?? this.status,
        addressee: addressee ?? this.addressee,
        contact: contact ?? this.contact,
        address: address ?? this.address,
        district: district ?? this.district,
        hasDefault: hasDefault != null ? hasDefault : this.hasDefault,
        regionIds: regionIds ?? this.regionIds,
        editedAddress: editedAddress ?? this.editedAddress,
      );

  @override
  List<Object> get props => [
        status,
        addressee,
        contact,
        district,
        address,
        hasDefault,
        regionIds,
        editedAddress
      ];
}
