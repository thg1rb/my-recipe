import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// StateNotifier to manage the panel controller
class PanelControllerNotifier extends StateNotifier<PanelController> {
  PanelControllerNotifier() : super(PanelController());

  void openPanel() => state.open();
  void closePanel() => state.close();
  void togglePanel() => state.isPanelOpen ? state.close() : state.open();
}

// Riverpod provider to access the PanelController
final panelControllerProvider =
    StateNotifierProvider<PanelControllerNotifier, PanelController>(
  (ref) => PanelControllerNotifier(),
);
