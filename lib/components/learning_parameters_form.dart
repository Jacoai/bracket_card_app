import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/components/time_input_field.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../generated/l10n.dart';
import '../navigation/route.dart';

class LearningParametersWidget extends StatefulWidget {
  const LearningParametersWidget({super.key, required this.cardBox});
  final CardBox cardBox;
  @override
  State<LearningParametersWidget> createState() =>
      _LearningParametersWidgetState();
}

class _LearningParametersWidgetState extends State<LearningParametersWidget> {
  Duration _time = Duration.zero;
  bool timeShown = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            SLocale.of(context).learning,
            style: AppTextStyles.baseText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text("${SLocale.of(context).cards}: ${SLocale.of(context).all}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(SLocale.of(context).timed),
              Checkbox(
                semanticLabel: "time",
                value: timeShown,
                onChanged: (value) {
                  setState(() {
                    timeShown = value!;
                  });
                },
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(SLocale.of(context).time),
                  ),
                  TimeInputField(
                    enabled: timeShown,
                    onChanged: (p0) => setState(() {
                      _time = p0;
                    }),
                  ),
                  //
                ],
              ),
            ],
          ),
        ),
        AdaptiveButton(
          label: SLocale.of(context).startLearning,
          onPressed: widget.cardBox.cardIds.isNotEmpty
              ? () => context.push(
                    AppRoute.learning.path,
                    extra: (
                      timeShown && _time != Duration.zero
                          ? _time
                          : Duration.zero,
                      widget.cardBox,
                    ),
                  )
              : null,
        ),
      ],
    );
  }
}
