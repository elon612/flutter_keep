part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class PhoneOnChanged extends RegisterEvent {
  PhoneOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [];
}

class SecurityOnChanged extends RegisterEvent {
  SecurityOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class SecurityButtonOnClicked extends RegisterEvent {

  @override
  List<Object> get props => [];
}

class SecurityNumberOnChanged extends RegisterEvent {

  @override
  List<Object> get props => [];
}

class NameOnChanged extends RegisterEvent {
  NameOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class PasswordOnChanged extends RegisterEvent {
  PasswordOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [];
}

class AgreementOnChecked extends RegisterEvent {
  @override
  List<Object> get props => [];
}

class RegisterButtonOnClicked extends RegisterEvent {
  @override
  List<Object> get props => [];
}
