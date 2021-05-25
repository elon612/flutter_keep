part of 'register_bloc.dart';

enum RegisterError {
  noError,
  agreementUnUnchecked,
}

class RegisterState extends Equatable {
  const RegisterState(
      {this.phone = const PhoneInput.pure(),
      this.security = const SecurityInput.pure(),
      this.name = const NameInput.pure(),
      this.password = const PasswordInput.pure(),
      this.status = FormzStatus.pure,
      this.securityNumber = 60,
      this.agreementChecked = false,
      this.error = RegisterError.noError});

  final PhoneInput phone;

  final int securityNumber;

  final SecurityInput security;

  final NameInput name;

  final PasswordInput password;

  final FormzStatus status;

  final bool agreementChecked;

  final RegisterError error;

  Stream<RegisterState> copyErrorWithReset(RegisterError error) async* {
    yield this.copyWith(error: error);
    yield this.copyWith(error: RegisterError.noError);
  }

  RegisterState copyWith(
          {PhoneInput phone,
          int securityNumber,
          SecurityInput security,
          NameInput name,
          PasswordInput password,
          FormzStatus status,
          bool agreementChecked,
          RegisterError error}) =>
      RegisterState(
        phone: phone ?? this.phone,
        securityNumber: securityNumber ?? this.securityNumber,
        security: security ?? this.security,
        name: name ?? this.name,
        password: password ?? this.password,
        status: status ?? this.status,
        agreementChecked:
            agreementChecked != null ? agreementChecked : this.agreementChecked,
        error: error ?? this.error,
      );

  @override
  List<Object> get props => [
        phone,
        securityNumber,
        security,
        name,
        password,
        status,
        agreementChecked,
        error,
      ];
}
