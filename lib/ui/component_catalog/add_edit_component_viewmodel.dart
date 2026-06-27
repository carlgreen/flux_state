import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';

class AddEditComponentViewModel extends ChangeNotifier {
  AddEditComponentViewModel({
    required this._inventoryRepository,
    required this._componentType,
  });

  final InventoryRepository _inventoryRepository;
  final String _componentType;

  String get componentType => _componentType;

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
