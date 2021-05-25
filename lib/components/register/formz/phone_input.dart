import 'package:formz/formz.dart';

enum PhoneInputError { empty, invalid }

class PhoneInput extends FormzInput<String, PhoneInputError> {
  const PhoneInput.pure([String value = '']) : super.pure(value);
  const PhoneInput.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneInputError validator(String value) {
    if (value.isEmpty) return PhoneInputError.empty;
    if (!RegExp(r"^1[3-9]\d{9}$").hasMatch(value)) {
      return PhoneInputError.invalid;
    }
    return null;
  }
}
