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

  Iterable<Component> _filter(
    List<Component> all,
    ComponentCategory? selectedCat,
    String searchQ,
  ) => all.where((c) {
    if (selectedCat != null && c.category != selectedCat) return false;
    if (searchQ.isNotEmpty) {
      final q = searchQ.toLowerCase();
      if (!c.display().toLowerCase().contains(q)) {
        return false;
      }
    }
    return true;
  });

  UnmodifiableListView<Component> components(
    ComponentCategory? selectedCat,
    String searchQ,
  ) {
    _components.sort();
    return UnmodifiableListView(_filter(_components, selectedCat, searchQ));
  }

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
      final components = _inventoryRepository.components;
      _components.clear();
      _components.addAll(components);

      // ...

      // return userResult;
      return;
    } finally {
      notifyListeners();
    }
  }
}
