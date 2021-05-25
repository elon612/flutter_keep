import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/blocs/blocs.dart';
import 'package:flutter_keep/repositories/repositories.dart';

class BlocWrapper extends StatelessWidget {
  const BlocWrapper({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthenticationBloc(
                  repository: context.read<AuthenticationRepository>(),
                  userRepository: context.read<UserRepository>(),
                )..add(AuthenticationAppStarted())),
      ],
      child: child,
    );
  }
}
