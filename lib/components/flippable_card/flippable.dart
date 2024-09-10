part of 'flippable_card.dart';

class Flippable extends StatelessWidget {
  const Flippable({
    super.key,
    required this.front,
    required this.back,
    this.flipped = false,
    this.onEnd,
  });
  final FloatingCard front;
  final FloatingCard back;
  final bool flipped;
  final Function()? onEnd;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: flipped ? 180.0 : 0.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      onEnd: onEnd,
      builder: (context, value, child) {
        final content = value >= 90 ? back : front;
        return Rotated(
          rotationY: value,
          child: Rotated(
            rotationY: value >= 90 ? 180 : 0,
            child: AnimatedBackground(
              child: content,
            ),
          ),
        );
      },
    );
  }
}
