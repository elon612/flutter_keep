import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/components/login/formz/formz.dart';
import 'package:flutter_keep/repositories/repositories.dart';
import 'package:formz/formz.dart';



part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({AuthenticationRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(LoginState());

  AuthenticationRepository _repository;

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is LoginFormSubmitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is UserNameOnChanged) {
      final name = NameInput.dirty(event.value);
      yield state.copyWith(
        username: name.valid ? name : NameInput.pure(event.value),
        formStatus: Formz.validate([
          name,
          state.password,
        ]),
      );
    } else if (event is PasswordOnChanged) {
      final password = PasswordInput.dirty(event.value);
      yield state.copyWith(
          password: password.valid ? password : PasswordInput.pure(event.value),
          formStatus: Formz.validate([state.username, password]));
    }
  }

  Stream<LoginState> _mapSubmittedToState(LoginFormSubmitted event) async* {
    final name = NameInput.dirty(state.username.value);
    final password = PasswordInput.dirty(state.password.value);

    yield state.copyWith(
        username: name,
        password: password,
        formStatus: Formz.validate([name, password]));

    if (state.formStatus.isValidated) {
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress);
      try {
        await _repository.logIn(state.username.value, state.password.value);
        yield state.copyWith(formStatus: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.copyWith(
            formStatus: FormzStatus.submissionFailure, errorMessage: e?.error);
      }
    }
  }
}

