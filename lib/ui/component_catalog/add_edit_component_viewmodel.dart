import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';

class AddEditComponentViewModel extends ChangeNotifier {
  AddEditComponentViewModel({
    required this._inventoryRepository,
    this.initialCategory,
  });

  final InventoryRepository _inventoryRepository;
  final ComponentCategory? initialCategory;
  late ComponentCategory category =
      initialCategory ?? ComponentCategory.resistor;

  void save(dynamic component, int quantity) {
    component.count = quantity;

    switch (component) {
      case Resistor r:
        _inventoryRepository.addResistor(r);
      case Diode d:
        _inventoryRepository.addDiode(d);
      default:
        debugPrint(
          "unexpected component: $component (${component.runtimeType})",
        );
        return;
    }

    notifyListeners();
  }
}
