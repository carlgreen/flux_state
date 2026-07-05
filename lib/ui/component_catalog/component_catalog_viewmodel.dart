import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';

class ComponentCatalogViewModel extends ChangeNotifier {
  ComponentCatalogViewModel({required this._inventoryRepository});

  final InventoryRepository _inventoryRepository;

  Iterable<Resistor> get resistors => _inventoryRepository.resistors;
  Iterable<Diode> get diodes => _inventoryRepository.diodes;

  Iterable<Component> components(ComponentCategory componentType) {
    return switch (componentType) {
      ComponentCategory.resistor => _inventoryRepository.resistors,
      ComponentCategory.diode => _inventoryRepository.diodes,
    };
  }

  Iterable<Component> all() {
    final all = <Component>[];
    all.addAll(_inventoryRepository.resistors);
    all.addAll(_inventoryRepository.diodes);
    return all;
  }
}
