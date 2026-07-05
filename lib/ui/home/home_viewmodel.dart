import 'package:flux_state/app_constants.dart';
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
      (d) => Component(category: ComponentCategory.diode, quantity: d.count),
    );
    components.addAll(diodes);

    return DashboardStats.fromComponents(components);
  }
}

enum StockStatus { inStock, lowStock, outOfStock }

class Component {
  final ComponentCategory category;
  final int quantity;

  const Component({required this.category, required this.quantity});

  StockStatus get stockStatus {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= AppConstants.lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }
}

class DashboardStats {
  final int totalTypes;
  final int totalUnits;
  final int lowStockCount;
  final int outOfStockCount;
  final Map<ComponentCategory, int> countByCategory;

  const DashboardStats({
    required this.totalTypes,
    required this.totalUnits,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.countByCategory,
  });

  factory DashboardStats.fromComponents(List<Component> components) {
    int units = 0;
    int low = 0;
    int out = 0;
    final Map<ComponentCategory, int> byCat = {};

    for (final c in components) {
      units += c.quantity;
      if (c.stockStatus == StockStatus.lowStock) low++;
      if (c.stockStatus == StockStatus.outOfStock) out++;
      byCat[c.category] = (byCat[c.category] ?? 0) + 1;
    }

    return DashboardStats(
      totalTypes: components.length,
      totalUnits: units,
      lowStockCount: low,
      outOfStockCount: out,
      countByCategory: byCat,
    );
  }
}
