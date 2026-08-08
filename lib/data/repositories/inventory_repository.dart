import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';

class InventoryRepository {
  final List<Component> _components = List.empty(growable: true);

  InventoryRepository();

  Iterable<Component> get components => List.unmodifiable(_components);

  void addComponent(Component c) {
    _components.add(c);
  }

  void saveComponent(Component update) {
    final idx = _components.indexWhere((c) => (c.id == update.id));
    if (idx >= 0) {
      _components[idx] = update;
    }
  }

  void add(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int quantity,
  ) {
    final Component c;
    switch (category) {
      case ComponentCategory.resistor:
        c = Resistor.fromAttrs(id, attrs);
      case ComponentCategory.diode:
        c = Diode.fromAttrs(id, attrs);
    }
    c.quantity = quantity;
    addComponent(c);
  }

  void save(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int qty,
  ) {
    final component = load(id);
    if (component != null) {
      final update = component.updateFromAttrs(attrs);
      update.quantity = qty;
      saveComponent(update);
    }
  }

  Component? load(String id) {
    return components.where((c) => c.id == id).singleOrNull;
  }
}
