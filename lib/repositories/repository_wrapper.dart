import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keep/repositories/repositories.dart';

class RepositoryWrapper extends StatefulWidget {
  const RepositoryWrapper({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  _RepositoryWrapperState createState() => _RepositoryWrapperState();
}

class _RepositoryWrapperState extends State<RepositoryWrapper> {

  UserRepository _userRepository;
  ProductRepository _productRepository;


  @override
  void initState() {
    _productRepository = ProductRepository();
    _userRepository = UserRepository(productRepository: _productRepository);
    super.initState();
  }

  @override
  void dispose() {
    _userRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider(
          create: (context) => AuthenticationRepository(_userRepository),
        ),
        RepositoryProvider(create: (_) => HomeRepository()),
        RepositoryProvider(create: (_) => HomeScreenRepository()),
        RepositoryProvider(
          create: (_) => ProductRepository(),
        )
      ],
      child: widget.child,
    );
  }
}
