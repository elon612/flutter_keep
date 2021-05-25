part of 'login_bloc.dart';

class LoginState extends Equatable {
  LoginState({
    this.formStatus = FormzStatus.pure,
    this.username = const NameInput.pure(''),
    this.password = const PasswordInput.pure(''),
    this.errorMessage,
  });

  final FormzStatus formStatus;
  final NameInput username;
  final PasswordInput password;

  final String errorMessage;

  LoginState copyWith({
    FormzStatus formStatus,
    NameInput username,
    PasswordInput password,
    String errorMessage,
  }) {
    return LoginState(
      formStatus: formStatus ?? this.formStatus,
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    formStatus,
    username,
    password,
    errorMessage
  ];
}
