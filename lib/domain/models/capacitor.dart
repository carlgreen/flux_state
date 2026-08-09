import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Capacitor extends Component {
  static const valueKey = 'value';
  static const voltageKey = 'voltage_v';
  static const toleranceKey = 'tolerance_pct';
  static const materialKey = 'material';
  static const polarisedKey = 'polarised';

  Capacitor({
    required super.id,
    required this.value,
    this.voltage,
    this.tolerance,
    this.material,
    required this.polarised,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.capacitor,
         attrs: {
           valueKey: value,
           voltageKey: voltage,
           toleranceKey: tolerance,
           materialKey: material,
           polarisedKey: polarised,
         },
       );

  final int value;
  final int? voltage;
  final String? tolerance;
  final String? material;
  final bool polarised;

  // String get valueString => formatResistorValue(value);
  // String get powerString =>
  //     power != null ? formatResistorPowerRating(power!) : '';
  // String get toleranceString =>
  //     tolerance != null ? formatResistorTolerance(tolerance!) : '';
  // String get packageString => package != null ? ' $package' : '';

  @override
  String display() {
    var main = value.toString();
    if (polarised) {
      main = '$main polarised';
    }
    if (voltage != null) {
      main = '$value $voltage';
    }
    if (tolerance != null) {
      main = '$main $tolerance';
    }
    var details = '';
    if (material != null) {
      details = '$details $material';
    }
    if (details.isNotEmpty) {
      details = ' (${details.trim()})';
    }
    return '$main$details';
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Capacitor &&
      value == other.value &&
      voltage == other.voltage &&
      tolerance == other.tolerance &&
      material == other.material &&
      polarised == other.polarised &&
      quantity == other.quantity;

  @override
  int get hashCode =>
      Object.hash(value, voltage, tolerance, material, polarised, quantity);

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    int value = this.value;
    int? voltage = this.voltage;
    String? tolerance = this.tolerance;
    String? material = this.material;
    bool polarised = this.polarised;
    // TODO some error handling here
    attrs.forEach((k, v) {
      switch (k) {
        case Capacitor.valueKey:
          value = int.parse(v);
        case Capacitor.voltageKey:
          voltage = int.parse(v);
        case Capacitor.toleranceKey:
          tolerance = v;
        case Capacitor.materialKey:
          material = v;
        case Capacitor.polarisedKey:
          polarised = bool.parse(v);
        default:
          debugPrint('unknown field $k');
      }
    });
    final update = Capacitor(
      id: id,
      value: value,
      voltage: voltage,
      tolerance: tolerance,
      material: material,
      polarised: polarised,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    // TODO consider tryParse?
    return Capacitor(
      id: id,
      value: int.parse(attrs[Capacitor.valueKey]),
      voltage: attrs[Capacitor.voltageKey] != null
          ? int.parse(attrs[Capacitor.voltageKey])
          : null,
      tolerance: attrs[Capacitor.toleranceKey],
      material: attrs[Capacitor.materialKey],
      polarised: attrs[Capacitor.polarisedKey] ?? false,
    );
  }
}
