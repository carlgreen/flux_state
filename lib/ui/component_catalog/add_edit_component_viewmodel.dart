import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:uuid/uuid.dart';

class AddEditComponentViewModel extends ChangeNotifier {
  AddEditComponentViewModel({
    required this._inventoryRepository,
    this.componentId,
    this.initialCategory,
  }) {
    if (componentId != null) {
      _load(componentId!);
    }
  }

  final InventoryRepository _inventoryRepository;
  final String? componentId;
  final ComponentCategory? initialCategory;
  late ComponentCategory category =
      initialCategory ?? ComponentCategory.resistor;

  Component? _component;

  Component? get component => _component;

  Future<void> _load(String id) async {
    final result =
        _inventoryRepository.resistors
            .where((c) => c.id == componentId)
            .singleOrNull ??
        _inventoryRepository.diodes
            .where((c) => c.id == componentId)
            .singleOrNull;
    // switch (result) {
    //   case Ok<Booking>():
    //     _log.fine('Loaded booking $id');
    //     _booking = result.value;
    //     notifyListeners();
    //   case Error<Booking>():
    //     _log.warning('Failed to load booking $id');
    // }
    // _log.fine('Loaded component $id');
    // _component = result.value;
    _component = result;
    notifyListeners();

    return;
  }

  Future<void> save(Map<String, dynamic> attrs, int quantity) async {
    final id = const Uuid().v4();
    switch (category) {
      case ComponentCategory.resistor:
        final r = Resistor(
          id: id,
          value: int.parse(attrs[Resistor.valueKey]),
          tolerance: int.parse(attrs[Resistor.toleranceKey]),
          power: int.parse(attrs[Resistor.powerKey]),
          quantity: quantity,
        );
        _inventoryRepository.addResistor(r);
      case ComponentCategory.diode:
        final d = Diode(id: id, code: attrs[Diode.codeKey], quantity: quantity);
        _inventoryRepository.addDiode(d);
    }

    notifyListeners();
  }

  Future<void> update(String id, Map<String, dynamic> attrs, int qty) async {
    switch (category) {
      case ComponentCategory.resistor:
        final r = _inventoryRepository.resistors
            .where((c) => c.id == id)
            .firstOrNull;
        if (r != null) {
          int value = r.value;
          int tolerance = r.tolerance;
          int power = r.power;
          attrs.forEach((k, v) {
            switch (k) {
              case Resistor.valueKey:
                value = int.parse(v);
              case Resistor.toleranceKey:
                tolerance = int.parse(v);
              case Resistor.powerKey:
                power = int.parse(v);
              default:
                debugPrint('unknown field $k');
            }
          });
          final update = Resistor(
            id: id,
            value: value,
            tolerance: tolerance,
            power: power,
            quantity: qty,
          );
          _inventoryRepository.saveResistor(update);
        }
      case ComponentCategory.diode:
        final d = _inventoryRepository.diodes
            .where((c) => c.id == id)
            .firstOrNull;
        if (d != null) {
          String code = d.code;
          attrs.forEach((k, v) {
            switch (k) {
              case Diode.codeKey:
                code = v;
              default:
                debugPrint('unknown field $k');
            }
          });
          final update = Diode(id: id, code: code, quantity: qty);
          _inventoryRepository.saveDiode(update);
        }
    }
  }
}
