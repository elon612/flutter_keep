part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class UserNameOnChanged extends LoginEvent {
  UserNameOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class PasswordOnChanged extends LoginEvent {
  PasswordOnChanged(this.value);
  final String value;

  @override
  List<Object> get props => [value];
}

class LoginFormSubmitted extends LoginEvent {}
