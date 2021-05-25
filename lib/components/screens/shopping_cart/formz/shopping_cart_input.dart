import 'package:formz/formz.dart';

enum ShoppingCartInputError { empty }

class ShoppingCartInput
    extends FormzInput<List<dynamic>, ShoppingCartInputError> {
  const ShoppingCartInput.pure([List<dynamic> value = const <dynamic>[]])
      : super.pure(value);
  const ShoppingCartInput.dirty([List<dynamic> value = const <dynamic>[]])
      : super.dirty(value);

  @override
  ShoppingCartInputError validator(List value) =>
      value.isEmpty ? ShoppingCartInputError.empty : null;
}
