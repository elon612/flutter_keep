import 'package:formz/formz.dart';

enum SecurityInputError { empty }

class SecurityInput extends FormzInput<String, SecurityInputError> {
  const SecurityInput.pure([String value = '']) : super.pure(value);
  const SecurityInput.dirty([String value = '']) : super.dirty(value);

  @override
  SecurityInputError validator(String value) =>
      value.isEmpty ? SecurityInputError.empty : null;
}
