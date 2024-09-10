import 'package:flutter/material.dart';
import 'label_with_tooltip.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    super.key,
    required this.iconSelected,
    required this.iconBase,
    required this.label,
    required this.onChanged,
    this.value = false,
    this.tooltip,
  });
  final IconData iconSelected;
  final IconData iconBase;
  final String label;
  final bool value;
  final void Function(bool) onChanged;
  final String? tooltip;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool switchValue;
  late IconData iconData;

  @override
  void initState() {
    super.initState();

    switchValue = widget.value;
    iconData = switchValue ? widget.iconSelected : widget.iconBase;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 175,
          child: LabelWithToolTip(
            label: widget.label,
            tooltip: widget.tooltip,
          ),
        ),
        Switch(
          value: switchValue,
          onChanged: (value) {
            widget.onChanged(value);
            setState(
              () {
                switchValue = !switchValue;
                iconData = switchValue ? widget.iconSelected : widget.iconBase;
              },
            );
          },
          thumbIcon: MaterialStatePropertyAll(Icon(iconData)),
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
