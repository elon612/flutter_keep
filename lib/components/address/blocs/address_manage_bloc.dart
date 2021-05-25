import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/address/formz/formz.dart';
import 'package:flutter_keep/components/register/formz/formz.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:formz/formz.dart';

part 'address_manage_event.dart';
part 'address_manage_state.dart';

class AddressManageBloc extends Bloc<AddressManageEvent, AddressManageState> {
  AddressManageBloc({UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AddressManageState());

  final UserRepository _userRepository;

  @override
  Stream<AddressManageState> mapEventToState(
    AddressManageEvent event,
  ) async* {
    if (event is AddressManageOnLoaded) {
      yield* _mapAddressOnLoadedToState(event);
    } else if (event is AddresseeOnChanged) {
      yield _mapAddresseeOnChangedToState(event);
    } else if (event is ContactOnChanged) {
      yield _mapContactOnChangedToState(event);
    } else if (event is DistrictOnChanged) {
      yield _mapDistrictOnChangedToState(event);
    } else if (event is AddressOnChanged) {
      yield _mapAddressOnChangedToState(event);
    } else if (event is DefaultOnSwitched) {
      yield state.copyWith(hasDefault: event.value);
    } else if (event is AddressManageOnDeleted) {
      yield _mapAddressOnDeletedToState();
    } else if (event is AddressManageOnSubmitted) {
      yield* _mapAddressOnSubmittedToState();
    }
  }

  Stream<AddressManageState> _mapAddressOnSubmittedToState() async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);

      final ids = state.regionIds;
      final address = state.address.value.trim();
      final mobile = state.contact.value.trim();
      final addressee = state.addressee.value.trim();
      final hasDefault = state.hasDefault;
      final List<String> splits = state.district.value.split(' ');
      // try {
        if (state.editedAddress != null) {
          await _userRepository.updateAddress(
              state.editedAddress.addrId,
              ids[0],
              ids[1],
              ids[2],
              address,
              addressee,
              mobile,
              splits[0],
              splits[1],
              splits[2],
              hasDefault);
        } else {
          await _userRepository.createAddress(ids[0], ids[1], ids[2], address,
              addressee, mobile, splits[0], splits[1], splits[2], hasDefault);
        }
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      // } catch (e) {
      // }
    }
  }

  AddressManageState _mapAddressOnDeletedToState() {
    _userRepository.deleteAddress(state.editedAddress.addrId);
    return state.copyWith(status: FormzStatus.submissionSuccess);
  }

  AddressManageState _mapAddressOnChangedToState(AddressOnChanged event) {
    final address = TextInput.dirty(value: event.value);
    final status = Formz.validate([
      address,
      state.district,
      state.contact,
      state.addressee,
    ]);
    return state.copyWith(address: address, status: status);
  }

  AddressManageState _mapDistrictOnChangedToState(DistrictOnChanged event) {
    final district = TextInput.dirty(value: event.value);
    final status = Formz.validate([
      district,
      state.contact,
      state.addressee,
      state.address,
    ]);
    return state.copyWith(
        district: district, status: status, regionIds: event.regionIds);
  }

  AddressManageState _mapContactOnChangedToState(ContactOnChanged event) {
    final contact = PhoneInput.dirty(event.value);
    final status = Formz.validate([
      contact,
      state.addressee,
      state.district,
      state.address,
    ]);
    return state.copyWith(contact: contact, status: status);
  }

  AddressManageState _mapAddresseeOnChangedToState(AddresseeOnChanged event) {
    final addressee = TextInput.dirty(value: event.value);
    final status = Formz.validate([
      addressee,
      state.contact,
      state.district,
      state.address,
    ]);
    return state.copyWith(addressee: addressee, status: status);
  }

  Stream<AddressManageState> _mapAddressOnLoadedToState(
    AddressManageOnLoaded event,
  ) async* {
    final address = event.address;
    if (address != null) {
      final districtName = [
        address.provinceName,
        address.cityName,
        address.countyName
      ].join(' ');
      final districtIds = [
        address.provinceId,
        address.cityId,
        address.countyId
      ];
      final addressee = TextInput.dirty(value: address.consignee);
      final contact = PhoneInput.dirty(address.mobile);
      final district = TextInput.dirty(value: districtName);
      final addressInfo = TextInput.dirty(value: address.address);

      final hasDefault = address.isCheck == '1';
      final status = Formz.validate([
        addressee,
        contact,
        district,
        addressInfo,
      ]);

      yield state.copyWith(
          status: status,
          addressee: addressee,
          contact: contact,
          district: district,
          address: addressInfo,
          regionIds: districtIds,
          editedAddress: address,
          hasDefault: hasDefault);
    }
  }
}
