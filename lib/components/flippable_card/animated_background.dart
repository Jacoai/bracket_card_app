part of 'flippable_card.dart';

class AnimatedBackground extends StatelessWidget {
  final FloatingCard child;
  const AnimatedBackground({
    required this.child,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: child.width,
      height: child.height,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: child,
    );
  }
}
