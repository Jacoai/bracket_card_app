import 'dart:async';

import 'package:flutter/material.dart';

class LeftNavigationPanelController extends ChangeNotifier {
  LeftNavigationPanelController({
    required int selectedIndex,
    bool? extended,
  }) : _selectedIndex = selectedIndex {
    _setExtedned(
      extended ?? false,
    );
  }

  int _selectedIndex;
  bool _extended = false;

  final _extendedController = StreamController<bool>.broadcast();

  Stream<bool> get extendStream =>
      _extendedController.stream.asBroadcastStream();

  int get selectedIndex => _selectedIndex;

  bool get extended => _extended;

  void selectIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  void toggleExtended() {
    _extended = !_extended;
    _extendedController.add(_extended);
    notifyListeners();
  }

  void _setExtedned(bool val) {
    _extended = val;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _extendedController.close();
    super.dispose();
  }
}
