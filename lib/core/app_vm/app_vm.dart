import 'package:flutter/material.dart';

import 'vm_state_enum.dart';
export 'vm_state_enum.dart';

abstract class AppViewModel extends ChangeNotifier {
  VmState _viewState = VmState.none;
  bool _disposed = false;

  VmState get viewState => _viewState;
  bool get hasEncounteredError => _viewState == VmState.error;
  bool get isBusy => _viewState == VmState.busy;

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }

  @protected
  void setState([VmState? viewState]) {
    if (viewState != null) _viewState = viewState;
    if (!_disposed && hasListeners) notifyListeners();
  }
}
