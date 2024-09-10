import 'dart:async';

import 'package:bracket_card_app/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final IconData? clearSuffixIcon;
  final void Function(String?) onTapSuffixIcon;
  final bool isSearchingField;
  final bool isAddingTextField;
  final bool isCardField;
  final String? tooltip;
  final String? helperText;
  final String? initialValue;
  final int maxLines;
  final EdgeInsetsGeometry? padding;

  const CustomTextField({
    super.key,
    this.hint,
    this.isCardField = false,
    required this.onChanged,
    this.inputType = TextInputType.text,
    this.validator,
    required this.onTapSuffixIcon,
    this.clearSuffixIcon = Icons.clear,
    this.isSearchingField = false,
    this.tooltip,
    this.helperText = '',
    this.isAddingTextField = false,
    this.initialValue = '',
    this.maxLines = 1,
    this.padding,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late Color currentColor;
  late Color baseColor;
  bool enableAdding = false;
  String? errorMessage;
  late final TextEditingController _controller;
  Timer? _timer;

  void validate(String text) {
    setState(
      () {
        if (widget.validator != null &&
            (widget.validator!(text) != null || text.isEmpty)) {
          currentColor = const Color.fromRGBO(244, 67, 54, 1);
          errorMessage = widget.validator!(text);
          enableAdding = false;
        } else {
          currentColor = Theme.of(context).primaryColorDark;
          enableAdding = true;
          errorMessage = null;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(
      () {
        _timer?.cancel();
        _timer = Timer.periodic(
          const Duration(milliseconds: 500),
          (timer) {
            widget.onChanged(_controller.text);
            validate(_controller.text);
            _timer?.cancel();
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    baseColor = Theme.of(context).primaryColorDark;
    currentColor = baseColor;
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Center(
        child: TextFormField(
          textAlign: widget.isCardField ? TextAlign.center : TextAlign.left,
          validator: widget.validator,
          keyboardType: widget.inputType,
          onChanged: (value) {
            _timer?.cancel();
            _timer = Timer.periodic(
              const Duration(milliseconds: 500),
              (timer) {
                widget.onChanged(_controller.text);
                validate(_controller.text);
                _timer?.cancel();
              },
            );
          },
          controller: _controller,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            contentPadding: widget.padding,
            hintStyle: AppTextStyles.baseText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            labelText: widget.hint,
            helperText: widget.helperText,
            errorText: errorMessage,
            labelStyle: AppTextStyles.baseText,
            helperMaxLines: 3,
            errorMaxLines: 3,
            prefixIcon:
                widget.isSearchingField ? const Icon(Icons.search) : null,
            suffixIcon: _controller.value.text.isNotEmpty &&
                    _controller.value.text != '' &&
                    (!widget.isAddingTextField ||
                        (widget.isAddingTextField && enableAdding))
                ? IconButton(
                    tooltip: widget.tooltip ?? '',
                    onPressed: _controller.value.text.isNotEmpty
                        ? () {
                            widget.onTapSuffixIcon(_controller.value.text);

                            setState(
                              () {
                                _controller.clear();
                              },
                            );
                          }
                        : null,
                    icon: Icon(
                      widget.clearSuffixIcon,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
