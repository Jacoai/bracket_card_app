import 'package:flutter/material.dart';

import '../theme.dart';
import 'item_model.dart';

class LeftNavigationPanelItem extends StatefulWidget {
  const LeftNavigationPanelItem({
    super.key,
    required this.item,
    required this.extended,
    required this.isSelected,
    required this.theme,
    required this.onTap,
    required this.animationController,
  });

  final bool extended;
  final bool isSelected;
  final LeftNavigationPanelItemModel item;
  final LeftNavigationPanelTheme theme;
  final void Function() onTap;
  final AnimationController animationController;

  @override
  State<LeftNavigationPanelItem> createState() => _DrawerItem();
}

class _DrawerItem extends State<LeftNavigationPanelItem> {
  late Animation<double> _animation;
  var _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnterDrawerItem(),
      onExit: (_) => _onExitDrawerItem(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: (widget.isSelected
                  ? widget.theme.selectedItemDecoration
                  : widget.theme.itemDecoration)
              ?.copyWith(
                  color: _isHovered && !widget.isSelected
                      ? widget.theme.hoverColor
                      : null),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: widget.extended
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, widget) {
                  final value = ((1 - _animation.value) * 6).toInt();
                  if (value <= 0) {
                    return const SizedBox();
                  }
                  return Spacer(flex: value);
                },
              ),
              if (widget.item.icon != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _CustomIcon(
                    item: widget.item,
                    iconTheme: widget.isSelected
                        ? widget.theme.selectedIconTheme
                        : widget.theme.iconTheme,
                  ),
                ),
              Flexible(
                flex: 6,
                child: FadeTransition(
                  opacity: _animation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 8,
                    ),
                    child: Text(
                      widget.item.label ?? '',
                      style: widget.isSelected
                          ? widget.theme.selectedTextStyle
                          : (_isHovered)
                              ? widget.theme.hoverTextStyle
                              : widget.theme.textStyle,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEnterDrawerItem() {
    setState(() => _isHovered = true);
  }

  void _onExitDrawerItem() {
    setState(() => _isHovered = false);
  }
}

class _CustomIcon extends StatelessWidget {
  const _CustomIcon({
    required this.item,
    required this.iconTheme,
  });

  final LeftNavigationPanelItemModel item;
  final IconThemeData? iconTheme;

  @override
  Widget build(BuildContext context) {
    return Icon(
      item.icon,
      color: iconTheme?.color,
      size: iconTheme?.size,
      semanticLabel: item.label,
    );
  }
}
