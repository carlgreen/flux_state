import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';

class ComponentCatalogViewModel extends ChangeNotifier {
  ComponentCatalogViewModel({required this._inventoryRepository});

  final InventoryRepository _inventoryRepository;

  Iterable<Resistor> get resistors => _inventoryRepository.resistors;
  Iterable<Diode> get diodes => _inventoryRepository.diodes;

  Iterable<dynamic> components(String componentType) {
    return switch (componentType) {
      'Resistors' => _inventoryRepository.resistors,
      'Diodes' => _inventoryRepository.diodes,
      _ => List.empty(),
    };
  }
}
