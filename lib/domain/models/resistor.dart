import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Resistor extends Component {
  static const valueKey = 'value';
  static const toleranceKey = 'tolerance_pct';
  static const powerKey = 'power_w';
  static const packageKey = 'package';

  Resistor({
    required super.id,
    required this.value,
    this.tolerance,
    this.power,
    this.package,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.resistor,
         attrs: {
           valueKey: value,
           toleranceKey: tolerance,
           powerKey: power,
           packageKey: package,
         },
       );

  final int value;
  final String? tolerance;
  final String? power;
  final String? package;

  String get valueString => formatResistorValue(value);
  String get powerString =>
      power != null ? formatResistorPowerRating(power!) : '';
  String get toleranceString =>
      tolerance != null ? formatResistorTolerance(tolerance!) : '';
  String get packageString => package != null ? ' $package' : '';

  @override
  String display() {
    var value = valueString;
    var details = '';
    if (power != null) {
      value = '$value $powerString';
    }
    if (tolerance != null) {
      value = '$value $toleranceString';
    }
    if (package != null) {
      details = '$details $package';
    }
    if (details.isNotEmpty) {
      details = ' (${details.trim()})';
    }
    return '$value$details';
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Resistor &&
      value == other.value &&
      tolerance == other.tolerance &&
      power == other.power &&
      package == other.package &&
      quantity == other.quantity;

  @override
  int get hashCode => Object.hash(value, tolerance, power, package, quantity);

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    int value = this.value;
    String? tolerance = this.tolerance;
    String? power = this.power;
    String? package = this.package;
    attrs.forEach((k, v) {
      switch (k) {
        case Resistor.valueKey:
          value = int.parse(v);
        case Resistor.toleranceKey:
          tolerance = v;
        case Resistor.powerKey:
          power = v;
        case Resistor.packageKey:
          package = v;
        default:
          debugPrint('unknown field $k');
      }
    });
    final update = Resistor(
      id: id,
      value: value,
      tolerance: tolerance,
      power: power,
      package: package,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Resistor(
      id: id,
      value: int.parse(attrs[Resistor.valueKey]),
      tolerance: attrs[Resistor.toleranceKey],
      power: attrs[Resistor.powerKey],
      package: attrs[Resistor.packageKey],
    );
  }
}

String formatResistorValue(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)} MΩ';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)} kΩ';
  } else {
    return '$value Ω';
  }
}

String formatResistorPowerRating(String value) {
  return '$value W';
}

String formatResistorTolerance(String tolerance) {
  return '± $tolerance%';
}
