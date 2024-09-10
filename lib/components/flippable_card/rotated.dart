part of 'flippable_card.dart';

const double pi = 3.1415926;
const double degrees2Radians = pi / 180;

class Rotated extends StatelessWidget {
  const Rotated({
    super.key,
    required this.child,
    this.rotationY = 0,
  });

  final Widget child;
  final double rotationY;

  @override
  Widget build(BuildContext context) {
    Matrix4 rotationMatrix = Matrix4.identity()
      // магические числа, чтобы работало преобразование матрицы
      ..setEntry(3, 2, 0.001)
      ..rotateY(rotationY * degrees2Radians);
    return Transform(
      alignment: FractionalOffset.center,
      transform: rotationMatrix,
      child: child,
    );
  }
}
