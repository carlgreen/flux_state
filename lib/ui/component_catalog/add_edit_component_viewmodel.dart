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

  void save(Map<String, dynamic> attrs, int quantity) {
    switch (category) {
      case ComponentCategory.resistor:
        final r = Resistor(
          value: int.parse(attrs['value']),
          tolerance: int.parse(attrs['tolerance_pct']),
          power: int.parse(attrs['power_w']),
          count: quantity,
        );
        _inventoryRepository.addResistor(r);
      case ComponentCategory.diode:
        final d = Diode(code: attrs['code'], count: quantity);
        _inventoryRepository.addDiode(d);
    }

    notifyListeners();
  }
}
