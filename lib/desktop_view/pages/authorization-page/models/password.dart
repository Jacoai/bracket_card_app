import 'package:bracket_card_app/generated/l10n.dart';
import 'package:formz/formz.dart';

final class Password extends FormzInput<String, String> {
  const Password.pure([super.value = '']) : super.pure();
  const Password.dirty([super.value = '']) : super.dirty();

  static final RegExp regex =
      RegExp(r'''^[ a-zA-Z0-9_.!'"#$%&(),+-:;/<\=>?@`{|}~^*\/\[\]\\]*$''');

  @override
  String? validator(String? value) {
    if (value == null || value.length < 8) {
      return SLocale.current.passwordIsTooShort;
    } else if (value.length > 255) {
      return SLocale.current.passwordIsTooLong;
    } else if (!regex.hasMatch(value)) {
      return '${SLocale.current.passwordCanContain} [! " # \$ %  & \' ( ) * , +  - . / : ; < = > ? @ [ \\ ] ^ _` { | } ~].';
    } else {
      return null;
    }
  }
}
