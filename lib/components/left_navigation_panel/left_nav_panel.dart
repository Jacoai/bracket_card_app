import 'package:flutter/material.dart';
import 'controller.dart';
import 'left_nav_panel_item/item_view.dart';
import 'left_nav_panel_item/item_model.dart';
import 'theme.dart';

export 'controller.dart';
export 'left_nav_panel_item/item_view.dart';
export 'left_nav_panel_item/item_model.dart';
export 'theme.dart';

typedef NavigationPanelBuilder = Widget Function(
  BuildContext context,
  bool extended,
);

class LeftNavigationPanel extends StatefulWidget {
  const LeftNavigationPanel({
    super.key,
    required this.controller,
    this.items = const [],
    this.theme = const LeftNavigationPanelTheme(),
    this.extendedTheme,
    this.headerBuilder,
    this.exitItem,
    this.toggleButtonBuilder,
    this.animationDuration = const Duration(milliseconds: 400),
    this.collapseIcon = Icons.arrow_back_ios_new,
    this.extendIcon = Icons.arrow_forward_ios,
  });

  final LeftNavigationPanelTheme theme;

  final LeftNavigationPanelTheme? extendedTheme;

  final List<LeftNavigationPanelItemModel> items;

  final LeftNavigationPanelController controller;

  final NavigationPanelBuilder? headerBuilder;
  final LeftNavigationPanelItemModel? exitItem;
  final LeftNavigationPanelItem? toggleButtonBuilder;
  final Duration animationDuration;

  ///иконка сужения
  final IconData collapseIcon;

  ///иконка расширения
  final IconData extendIcon;

  @override
  State<LeftNavigationPanel> createState() => _LeftNavigationPanelState();
}

class _LeftNavigationPanelState extends State<LeftNavigationPanel>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    if (widget.controller.extended) {
      _animationController?.forward();
    } else {
      _animationController?.reverse();
    }
    widget.controller.extendStream.listen(
      (extended) {
        if (_animationController?.isCompleted ?? false) {
          _animationController?.reverse();
        } else {
          _animationController?.forward();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final theme = widget.controller.extended
            ? widget.theme.copyWith(width: 180)
            : widget.theme;
        return AnimatedContainer(
          duration: widget.animationDuration,
          width: theme.width,
          height: theme.height,
          margin: theme.margin,
          curve: Curves.linear,
          decoration: theme.decoration,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleButton(theme, widget.collapseIcon, widget.extendIcon),
              widget.headerBuilder?.call(context, widget.controller.extended) ??
                  const SizedBox(),
              const SizedBox(),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return LeftNavigationPanelItem(
                      item: item,
                      theme: theme,
                      animationController: _animationController!,
                      extended: widget.controller.extended,
                      isSelected: widget.controller.selectedIndex == index,
                      onTap: () => _onItemSelected(item, index),
                    );
                  },
                ),
              ),
              widget.exitItem != null
                  ? _buildExitButton(theme, widget.exitItem!)
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }

  void _onItemSelected(LeftNavigationPanelItemModel item, int index) {
    widget.controller.selectIndex(index);
    item.onTap?.call();
  }

  Widget _buildExitButton(
      LeftNavigationPanelTheme t, LeftNavigationPanelItemModel item) {
    return LeftNavigationPanelItem(
      item: item,
      theme: t,
      animationController: _animationController!,
      extended: widget.controller.extended,
      isSelected: false,
      onTap: () => item.onTap?.call(),
    );
  }

  Widget _buildToggleButton(
    LeftNavigationPanelTheme theme,
    IconData collapseIcon,
    IconData extendIcon,
  ) {
    return InkWell(
      key: const Key('toggle_button'),
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        if (_animationController!.isAnimating) return;
        widget.controller.toggleExtended();
      },
      child: Row(
        mainAxisAlignment: widget.controller.extended
            ? MainAxisAlignment.end
            : MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Icon(
              widget.controller.extended ? collapseIcon : extendIcon,
              color: theme.iconTheme?.color,
              size: theme.iconTheme?.size,
            ),
          ),
        ],
      ),
    );
  }
}
