import 'dart:convert';

import 'package:flux_state/app_constants.dart';
import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/ic.dart';
import 'package:flux_state/domain/models/led.dart';
import 'package:flux_state/domain/models/potentiometer.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/domain/models/switch.dart';
import 'package:flux_state/domain/models/transistor.dart';

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

  factory Component.fromMap(Map<String, dynamic> attrs) {
    final id = attrs['id'] as String;
    final category = ComponentCategory.values.firstWhere(
      (c) => c.name == attrs['category'],
      // orElse: () => ComponentCategory.misc,
      orElse: () => throw Exception('bad category: ${attrs['category']}'),
    );
    final Component c;
    final realAttrs = json.decode(attrs['attrs']);
    switch (category) {
      case ComponentCategory.resistor:
        c = Resistor.fromAttrs(id, realAttrs);
      case ComponentCategory.capacitor:
        c = Capacitor.fromAttrs(id, realAttrs);
      case ComponentCategory.diode:
        c = Diode.fromAttrs(id, realAttrs);
      case ComponentCategory.led:
        c = Led.fromAttrs(id, realAttrs);
      case ComponentCategory.transistor:
        c = Transistor.fromAttrs(id, realAttrs);
      case ComponentCategory.ic:
        c = Ic.fromAttrs(id, realAttrs);
      case ComponentCategory.potentiometer:
        c = Potentiometer.fromAttrs(id, realAttrs);
      case ComponentCategory.switchComp:
        c = Switch.fromAttrs(id, realAttrs);
    }
    c.quantity = attrs['quantity'];

    return c;
  }

  Map<String, Object?> toMap();

  @override
  int compareTo(Component other) {
    return category.index.compareTo(other.category.index);
  }
}
