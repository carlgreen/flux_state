import 'package:flux_state/app_constants.dart';
import 'package:flux_state/domain/models/component_category.dart';

enum StockStatus { inStock, lowStock, outOfStock }

abstract class Component {
  final ComponentCategory category;
  int quantity;

  Component({required this.category, required this.quantity});

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
}
