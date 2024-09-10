import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/components/custom_app_bar/custom_app_bar.dart';
import 'package:bracket_card_app/components/flippable_card/flippable_card.dart';
import 'package:bracket_card_app/desktop_view/pages/learning_page/learning_page_bloc.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/timer_widget.dart';

class LearningPage extends StatelessWidget {
  const LearningPage(
      {super.key, required this.box, this.timeSet = Duration.zero});
  final CardBox box;
  final Duration timeSet;
  @override
  Widget build(BuildContext context) {
    final LearningPageBloc bloc = LearningPageBloc()
      ..add(LearningPageLoad(cardBox: box));
    return Scaffold(
      appBar: MyAppBar(
        canGoBack: true,
        title: "${SLocale.of(context).learningBox} ${box.boxName}",
        haveSearchField: false,
        onSearch: (p0) {},
        onClear: (p0) {},
      ),
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => bloc,
            child: BlocBuilder<LearningPageBloc, LearningPageState>(
              builder: (context, state) {
                if (state.status == LearningPageStatus.error) {
                  return Center(
                    child: Text(state.errorMessage!),
                  );
                } else if (state.status == LearningPageStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.status == LearningPageStatus.ready ||
                    state.status == LearningPageStatus.paused) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        constraints:
                            const BoxConstraints(maxHeight: 500, maxWidth: 500),
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            if (state.status == LearningPageStatus.ready)
                              Expanded(
                                child: FlippableCard(
                                  card: state.card!,
                                ),
                              )
                            else
                              Expanded(
                                child: Text(SLocale.of(context).paused),
                              ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AdaptiveButton(
                                    label: state.length - state.passedCards <= 1
                                        ? SLocale.of(context).finish
                                        : SLocale.of(context).next,
                                    onPressed: state.status ==
                                            LearningPageStatus.paused
                                        ? null
                                        : () =>
                                            bloc.add(LearningPageChangeCard()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AdaptiveButton(
                                    label: SLocale.of(context).skip,
                                    onPressed: state.status ==
                                                LearningPageStatus.paused ||
                                            state.length - state.passedCards <=
                                                1
                                        ? null
                                        : () =>
                                            bloc.add(LearningPageSkipCard()),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "${SLocale.of(context).passed}: ${state.passedCards} ${SLocale.of(context).of_msg} ${state.length}"),
                            ),
                            if (timeSet > Duration.zero)
                              TimerWidget(
                                warningMessage: SLocale.of(context)
                                    .stopLearningWarningMessage,
                                timeSet: timeSet,
                                onTimeout: () => bloc.add(LearningPageDone()),
                                onAbort: () => bloc.add(LearningPageDone()),
                                onPause: () => bloc.add(LearningPagePause()),
                                onResume: () => bloc.add(LearningPageResume()),
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state.status == LearningPageStatus.done) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                            "${SLocale.of(context).cardsPassed}: ${state.passedCards}"),
                        AdaptiveButton(
                          label: SLocale.of(context).goBack,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text(SLocale.of(context).unknownError),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
