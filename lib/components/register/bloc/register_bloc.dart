import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/register/formz/formz.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:formz/formz.dart';

import '../ticker.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({UserRepository userRepository, Ticker ticker})
      : assert(ticker != null),
        assert(userRepository != null),
        _ticker = ticker,
        _userRepository = userRepository,
        super(RegisterState());

  final Ticker _ticker;
  final UserRepository _userRepository;

  StreamSubscription<int> _streamSubscription;

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is PhoneOnChanged) {
      yield _mapPhoneOnChangedToState(event);
    } else if (event is SecurityOnChanged) {
      yield _mapSecurityOnChangedToState(event);
    } else if (event is NameOnChanged) {
      yield _mapNameOnChangedToState(event);
    } else if (event is PasswordOnChanged) {
      yield _mapPasswordOnChangedToState(event);
    } else if (event is SecurityButtonOnClicked) {
      yield* _mapSecurityButtonOnClickedToState(event);
    } else if (event is SecurityNumberOnChanged) {
      yield* _mapSecurityNumberOnChangedToState();
    } else if (event is AgreementOnChecked) {
      yield state.copyWith(agreementChecked: !state.agreementChecked);
    } else if (event is RegisterButtonOnClicked) {
      yield* _mapRegisterButtonOnClickedToState();
    }
  }

  Stream<RegisterState> _mapRegisterButtonOnClickedToState() async* {
    if (!state.agreementChecked) {
      yield* state.copyErrorWithReset(RegisterError.agreementUnUnchecked);
      return;
    }
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      final String phone = state.phone.value;
      final String security = state.security.value;
      final String name = state.name.value;
      final String password = state.password.value;
      await _userRepository.register(phone, security, name, password);
      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }

  Stream<RegisterState> _mapSecurityNumberOnChangedToState() async* {
    int number = state.securityNumber - 1;
    if (number == 0) {
      number = 60;
      _streamSubscription.cancel();
    }
    yield state.copyWith(securityNumber: number);
  }

  Stream<RegisterState> _mapSecurityButtonOnClickedToState(
      SecurityButtonOnClicked event) async* {
    if (state.securityNumber < 60) return;
    _streamSubscription = _ticker.tick(ticks: 60).listen((event) {
      add(SecurityNumberOnChanged());
    });
  }

  RegisterState _mapPasswordOnChangedToState(PasswordOnChanged event) {
    final password = PasswordInput.dirty(event.value);
    return state.copyWith(
        password: password,
        status: Formz.validate([
          state.phone,
          state.security,
          state.name,
          password,
        ]));
  }

  RegisterState _mapNameOnChangedToState(NameOnChanged event) {
    final name = NameInput.dirty(event.value);
    return state.copyWith(
        name: name,
        status: Formz.validate([
          state.phone,
          state.security,
          name,
          state.password,
        ]));
  }

  RegisterState _mapSecurityOnChangedToState(
    SecurityOnChanged event,
  ) {
    final security = SecurityInput.dirty(event.value);
    return state.copyWith(
        security: security,
        status: Formz.validate([
          state.phone,
          security,
          state.name,
          state.password,
        ]));
  }

  RegisterState _mapPhoneOnChangedToState(PhoneOnChanged event) {
    final phone = PhoneInput.dirty(event.value);
    return state.copyWith(
        phone: phone,
        status: Formz.validate([
          phone,
          state.security,
          state.name,
          state.password,
        ]));
  }
}

extension SecurityExtension on RegisterState {
  bool get started => securityNumber < 60;
}
