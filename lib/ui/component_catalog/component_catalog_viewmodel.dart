import 'package:flutter/material.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/main.dart';

class ComponentCatalogViewModel extends ChangeNotifier {
  ComponentCatalogViewModel({required this._inventoryRepository});

  final InventoryRepository _inventoryRepository;

  Iterable<Resistor> get resistors => _inventoryRepository.resistors;
  Iterable<Diode> get diodes => _inventoryRepository.diodes;

  void _addResistor() {
    _inventoryRepository.addResistor(
      Resistor(value: '10k', tolerance: '5%', power: '1/4W'),
    );
  }

  void _addDiode() {
    _inventoryRepository.addDiode(Diode(code: '1N34A'));
  }

  void add(String componentType) {
    switch (componentType) {
      case 'Resistors':
        _addResistor();
      case 'Diodes':
        _addDiode();
      default:
        debugPrint('unexpected component type "$componentType"');
    }

    notifyListeners();
  }

  Iterable<dynamic> components(String componentType) {
    return switch (componentType) {
      'Resistors' => _inventoryRepository.resistors,
      'Diodes' => _inventoryRepository.diodes,
      _ => List.empty(),
    };
  }
}
