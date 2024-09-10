import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:bracket_card_app/components/floating_card.dart';

part 'flippable.dart';
part 'rotated.dart';
part 'animated_background.dart';

class FlippableCard extends StatefulWidget {
  FlippableCard({
    super.key,
    required this.card,
  });
  final ValueNotifier<bool> flipped = ValueNotifier(false);
  final LearningCard card;

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard> {
  bool blocked = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
            onTap: () {
              if (blocked) return;
              widget.flipped.value = !widget.flipped.value;
              blocked = true;
            },
            child: ValueListenableBuilder(
              valueListenable: widget.flipped,
              builder: (context, value, child) {
                return Flippable(
                  onEnd: () => blocked = false,
                  front: FloatingCard(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    text: widget.card.frontNote,
                  ),
                  back: FloatingCard(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    text: widget.card.backNote,
                  ),
                  flipped: value,
                );
              },
            ));
      },
    );
  }
}
