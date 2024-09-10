import 'package:bracket_card_app/generated/l10n.dart';
import 'package:formz/formz.dart';

final class Username extends FormzInput<String, String> {
  const Username.pure([super.value = '']) : super.pure();
  const Username.dirty([super.value = '']) : super.dirty();

  static final RegExp regex = RegExp(r'^[a-zA-Z0-9_.]*$');

  @override
  String? validator(String? value) {
    if (value == null || value.length < 3) {
      return SLocale.current.usernameIsTooShort;
    } else if (value.length > 32) {
      return SLocale.current.usernameIsTooShort;
    } else if (regex.hasMatch(value)) {
      return null;
    } else {
      return SLocale.current.usernameCanContain;
    }
  }
}
