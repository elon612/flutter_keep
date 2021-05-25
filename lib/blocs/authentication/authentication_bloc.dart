import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';


class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {AuthenticationRepository repository, UserRepository userRepository})
      : assert(repository != null),
        assert(userRepository != null),
        _userRepository = userRepository,
        _authenticationRepository = repository,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription =
        _authenticationRepository.status.listen((status) {
      add(AuthenticationStatusChanged(status));
    });
  }

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;

  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationRepository.dispose();
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationAppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AuthenticationStatusChanged) {
      yield* _mapStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _logOut();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final user = _getUser();
    yield user != null
        ? AuthenticationState.authenticated(user)
        : const AuthenticationState.unauthenticated();
  }

  Stream<AuthenticationState> _mapStatusChangedToState(
      AuthenticationStatusChanged event) async* {
    switch (event.status) {
      case AuthenticationStatus.authenticated:
        final user = _getUser();
        yield user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated();
        break;
      case AuthenticationStatus.unauthenticated:
        yield const AuthenticationState.unauthenticated();
        break;
      default:
        yield const AuthenticationState.unknown();
        break;
    }
  }

  Future<void> _logOut() async {
    await _userRepository.clearUser();
    _authenticationRepository.logOut();
  }

  User _getUser() {
    try {
      return _userRepository.getUser();
    } on Exception {
      return null;
    }
  }
}
