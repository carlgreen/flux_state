import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/ic.dart';
import 'package:flux_state/domain/models/led.dart';
import 'package:flux_state/domain/models/potentiometer.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/domain/models/switch.dart';
import 'package:flux_state/domain/models/transistor.dart';

class InMemoryInventoryRepository implements InventoryRepository {
  final List<Component> _components = List.empty(growable: true);

  @override
  Future<Iterable<Component>> get components =>
      Future.value(List.unmodifiable(_components));

  void addComponent(Component c) {
    _components.add(c);
  }

  void saveComponent(Component update) {
    final idx = _components.indexWhere((c) => (c.id == update.id));
    if (idx >= 0) {
      _components[idx] = update;
    }
  }

  @override
  Future<int> add(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int quantity,
  ) {
    final Component c;
    switch (category) {
      case ComponentCategory.resistor:
        c = Resistor.fromAttrs(id, attrs);
      case ComponentCategory.capacitor:
        c = Capacitor.fromAttrs(id, attrs);
      case ComponentCategory.diode:
        c = Diode.fromAttrs(id, attrs);
      case ComponentCategory.led:
        c = Led.fromAttrs(id, attrs);
      case ComponentCategory.transistor:
        c = Transistor.fromAttrs(id, attrs);
      case ComponentCategory.ic:
        c = Ic.fromAttrs(id, attrs);
      case ComponentCategory.potentiometer:
        c = Potentiometer.fromAttrs(id, attrs);
      case ComponentCategory.switchComp:
        c = Switch.fromAttrs(id, attrs);
    }
    c.quantity = quantity;
    addComponent(c);

    return Future.value(1);
  }

  @override
  Future<int> save(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int qty,
  ) async {
    final component = await load(id);
    if (component != null) {
      final update = component.updateFromAttrs(attrs);
      update.quantity = qty;
      saveComponent(update);

      return Future.value(1);
    }

    return Future.error('no component for $id');
  }

  @override
  Future<Component?> load(String id) {
    return components.then((c) => c.where((c) => c.id == id).singleOrNull);
  }
}
