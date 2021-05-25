import 'package:formz/formz.dart';

enum PasswordInputError { empty }

class PasswordInput extends FormzInput<String, PasswordInputError> {
  const PasswordInput.pure([String value = '']) : super.pure(value);
  const PasswordInput.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordInputError validator(String value) =>
      value.isEmpty ? PasswordInputError.empty : null;
}
