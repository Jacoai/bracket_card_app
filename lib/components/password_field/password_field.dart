import 'package:bracket_card_app/desktop_view/pages/authorization-page/models/models.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.textEditingController,
    this.textInputAction,
    this.onChanged,
    this.labelText,
  });

  final TextEditingController textEditingController;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final String? labelText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;
  final FocusNode _focusNode = FocusNode();

  Password password = const Password.pure();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        passwordUnfocued();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 100,
      child: TextFormField(
        controller: widget.textEditingController,
        focusNode: _focusNode,
        obscureText: !isPasswordVisible,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            icon: const Icon(Icons.remove_red_eye),
            tooltip: isPasswordVisible
                ? SLocale.of(context).hidePassword
                : SLocale.of(context).showPassword,
          ),
          helperText: SLocale.of(context).password8char,
          labelText: widget.labelText,
          errorText: password.displayError,
          errorMaxLines: 2,
        ),
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
      ),
    );
  }

  void passwordUnfocued() {
    password = Password.dirty(widget.textEditingController.text);
    setState(() {});
  }
}
