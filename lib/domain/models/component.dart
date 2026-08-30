import 'package:flux_state/app_constants.dart';

import 'component_category.dart';

enum StockStatus { inStock, lowStock, outOfStock }

abstract class Component implements Comparable<Component> {
  final String id;
  final ComponentCategory category;
  int quantity;
  Map<String, dynamic> attrs;

  Component({
    required this.id,
    required this.category,
    required this.quantity,
    required this.attrs,
  });

  String display();

  void add() {
    quantity++;
  }

  void remove() {
    var q = quantity - 1;

    if (q < 0) {
      q = 0;
    }

    quantity = q;
  }

  StockStatus get stockStatus {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= AppConstants.lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  Map<dynamic, dynamic> get attributes => attrs;

  Component updateFromAttrs(Map<String, dynamic> attrs);

  @override
  int compareTo(Component other) {
    return category.index.compareTo(other.category.index);
  }
}
