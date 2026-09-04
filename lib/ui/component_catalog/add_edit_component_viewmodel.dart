import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:uuid/uuid.dart';

class AddEditComponentViewModel extends ChangeNotifier {
  AddEditComponentViewModel({
    required this._inventoryRepository,
    this.componentId,
    this.initialCategory,
  });

  final InventoryRepository _inventoryRepository;
  final String? componentId;
  final ComponentCategory? initialCategory;
  late ComponentCategory category =
      initialCategory ?? ComponentCategory.resistor;

  Component? _component;

  Component? get component => _component;

  Future<void> load() async {
    final id = componentId;
    if (id == null) {
      return;
    }

    final result = _inventoryRepository.load(id);
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
    _component = await result;
    notifyListeners();
  }

  Future<void> save(Map<String, dynamic> attrs, int quantity) async {
    final id = const Uuid().v4();

    _inventoryRepository.add(category, id, attrs, quantity);

    notifyListeners();
  }

  Future<void> update(String id, Map<String, dynamic> attrs, int qty) async {
    _inventoryRepository.save(category, id, attrs, qty);
  }
}
