import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';

class ComponentCatalogViewModel extends ChangeNotifier {
  ComponentCatalogViewModel({
    required this._inventoryRepository,
    this.initialCategory,
  }) {
    load();
  }

  final InventoryRepository _inventoryRepository;
  final ComponentCategory? initialCategory;

  final List<Component> _components = [];

  UnmodifiableListView<Component> get components =>
      UnmodifiableListView(_components);

  Future<void> load() async {
    try {
      // final componentsResult = await _inventoryRepository.components;
      // switch (componentsResult) {
      //   case Ok<List<Components>>():
      //     _components = componentsResult.value;
      //     _log.fine('Loaded components');
      //   case Error<List<Components>>():
      //     _log.warning('Failed to load components', componentsResult.error);
      // }
      final resistors = _inventoryRepository.resistors;
      final diodes = _inventoryRepository.diodes;
      _components.clear();
      _components.addAll(resistors);
      _components.addAll(diodes);

      // ...

      // return userResult;
      return;
    } finally {
      notifyListeners();
    }
  }
}
