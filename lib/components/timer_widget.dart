import 'dart:async';

import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../theme/theme.dart';
import 'adaptive_button.dart';
import 'error_messager/error_messager.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {super.key,
      required this.timeSet,
      this.onTimeout,
      this.onAbort,
      this.onPause,
      this.onResume,
      this.warningMessage});
  final Duration timeSet;
  final String? warningMessage;
  final Function()? onTimeout;
  final Function()? onAbort;
  final Function()? onPause;
  final Function()? onResume;
  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  bool paused = false;
  Timer? timer;
  Duration timeLeft = Duration.zero;
  @override
  void initState() {
    super.initState();
    timeLeft = widget.timeSet;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (paused) return;
      timeLeft -= const Duration(seconds: 1);
      if (timeLeft <= Duration.zero) {
        timer.cancel();
        widget.onTimeout?.call();
        paused = true;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    paused = true;
    if (timer != null) timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AdaptiveButton(
                  label: SLocale.of(context).abort,
                  onPressed: () async {
                    final answer = await showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorMesseger(
                              isWarningMessage: true,
                              errorName: widget.warningMessage ??
                                  SLocale.of(context).stopTimer);
                        });
                    if (answer) {
                      widget.onAbort?.call();
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AdaptiveButton(
                  label: paused
                      ? SLocale.of(context).resume
                      : SLocale.of(context).pause,
                  onPressed: () async {
                    if (paused) {
                      widget.onResume?.call();
                    } else {
                      widget.onPause?.call();
                    }
                    setState(() {
                      paused = !paused;
                    });
                  }),
            ),
          ],
        ),
        _buildTimerText(),
      ],
    );
  }

  Widget _buildTimerText() {
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    return Text(
      format(timeLeft),
      style: AppTextStyles.baseText,
    );
  }
}
