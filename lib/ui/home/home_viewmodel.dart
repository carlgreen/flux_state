import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component_category.dart';

class HomeViewModel {
  HomeViewModel({required this._inventoryRepository});

  final InventoryRepository _inventoryRepository;

  DashboardStats get stats {
    final List<Component> components = List.empty(growable: true);
    final resistors = _inventoryRepository.resistors.map(
      (r) => Component(category: ComponentCategory.resistor, quantity: r.count),
    );
    components.addAll(resistors);
    final diodes = _inventoryRepository.diodes.map(
      (r) => Component(category: ComponentCategory.diode, quantity: r.count),
    );
    components.addAll(diodes);

    return DashboardStats.fromComponents(components);
  }
}

class Component {
  final ComponentCategory category;
  final int quantity;

  const Component({required this.category, required this.quantity});
}

class DashboardStats {
  final int totalTypes;
  final int totalUnits;
  final Map<ComponentCategory, int> countByCategory;

  const DashboardStats({
    required this.totalTypes,
    required this.totalUnits,
    required this.countByCategory,
  });

  factory DashboardStats.fromComponents(List<Component> components) {
    int units = 0;
    final Map<ComponentCategory, int> byCat = {};

    for (final c in components) {
      units += c.quantity;
      byCat[c.category] = (byCat[c.category] ?? 0) + 1;
    }

    return DashboardStats(
      totalTypes: components.length,
      totalUnits: units,
      countByCategory: byCat,
    );
  }
}
