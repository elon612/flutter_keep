import 'dart:async';

import 'package:flutter_keep/models/models.dart';
import 'package:flutter_keep/repositories/repositories.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthenticationRepository {
  AuthenticationRepository(this.repository);
  final UserRepository repository;

  StreamController<AuthenticationStatus> _controller =
      StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  Future<void> logIn(String username, String password) async {
    final User user = User(userName: username);
    await repository.toLocalStored(user);
    _controller.add(AuthenticationStatus.authenticated);
  }

  void logOut() => _controller.add(AuthenticationStatus.unauthenticated);

  void dispose() => _controller.close();
}
