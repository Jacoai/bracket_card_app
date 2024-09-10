import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/formatters/numeric_range_formatter.dart';

class TimeInputField extends StatefulWidget {
  const TimeInputField({super.key, this.onChanged, required this.enabled});
  final Function(Duration)? onChanged;
  final bool enabled;
  @override
  TimeInputFieldState createState() => TimeInputFieldState();
}

class TimeInputFieldState extends State<TimeInputField> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 40,
          child: TextFormField(
            enabled: widget.enabled,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              NumericRangeFormatter(min: 0, max: 23),
            ],
            onChanged: (value) {
              setState(() {
                hours = int.tryParse(value) ?? 0;
              });
              widget.onChanged?.call(Duration(
                hours: hours,
                minutes: minutes,
                seconds: seconds,
              ));
            },
          ),
        ),
        const Text(":"),
        SizedBox(
          width: 40,
          child: TextFormField(
            enabled: widget.enabled,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              NumericRangeFormatter(min: 0, max: 59),
            ],
            onChanged: (value) {
              setState(() {
                minutes = int.tryParse(value) ?? 0;
              });
              widget.onChanged?.call(Duration(
                hours: hours,
                minutes: minutes,
                seconds: seconds,
              ));
            },
          ),
        ),
        const Text(":"),
        SizedBox(
          width: 40,
          child: TextFormField(
            textAlign: TextAlign.center,
            enabled: widget.enabled,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              NumericRangeFormatter(min: 0, max: 59),
            ],
            onChanged: (value) {
              setState(() {
                seconds = int.tryParse(value) ?? 0;
              });
              widget.onChanged?.call(Duration(
                hours: hours,
                minutes: minutes,
                seconds: seconds,
              ));
            },
          ),
        ),
      ],
    );
  }
}
