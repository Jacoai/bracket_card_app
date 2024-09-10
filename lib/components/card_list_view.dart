import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';

class LearningCardGridView extends StatelessWidget {
  const LearningCardGridView({
    super.key,
    required this.card,
    required this.onDelete,
    required this.onEdit,
    required this.canEdit,
    this.onSolvedChanged,
  });
  final bool canEdit;
  final LearningCard card;
  final void Function() onEdit;
  final void Function(bool result)? onSolvedChanged;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: card.isSolved ? Colors.green : Theme.of(context).primaryColor,
          width: card.isSolved ? 4 : 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        CustomPaint(
          foregroundPainter: card.isSolved ? IsSolvedPainter() : null,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  card.isSolved
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.star,
                            color: AppColors.accentYellow,
                          ),
                        )
                      : const SizedBox(),
                  const Spacer(),
                  canEdit
                      ? IconMenu(
                          list: [
                            IconButton(
                              onPressed: onDelete,
                              icon: const Icon(Icons.delete),
                              tooltip: SLocale.of(context).delete,
                            ),
                            IconButton(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit),
                              tooltip: SLocale.of(context).edit,
                            ),
                          ],
                        )
                      : onSolvedChanged != null
                          ? IconButton(
                              onPressed: () {
                                onSolvedChanged!(card.isSolved);
                              },
                              icon: Icon(
                                card.isSolved ? Icons.clear : Icons.check,
                              ),
                            )
                          : const SizedBox()
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                card.frontNote,
                                style: AppTextStyles.baseText
                                    .copyWith(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          card.backNote,
                          style: AppTextStyles.baseText.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class IconMenu extends StatefulWidget {
  const IconMenu({super.key, required this.list});
  final List<IconButton> list;

  @override
  State<IconMenu> createState() => _IconMenuState();
}

class _IconMenuState extends State<IconMenu> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isOpen
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  children: widget.list,
                )
              : const SizedBox(),
          IconButton(
            onPressed: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            icon: const Icon(
              Icons.menu,
            ),
          ),
        ],
      ),
    );
  }
}

class IsSolvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height / 3)
      ..quadraticBezierTo(
          size.width / 4, size.height / 6, size.width / 4 + 5, 0)
      ..lineTo(size.width / 4, 0)
      ..lineTo(size.width / 4 - 20, 0)
      ..quadraticBezierTo(size.width / 8, size.height / 6, 0, size.height / 4)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
