import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Potentiometer extends Component {
  static const valueKey = 'value';
  static const taperKey = 'taper';
  static const sizeKey = 'size_mm';
  static const shaftDiameterKey = 'shaft_diameter_mm';
  static const shaftLengthKey = 'shaft_length_mm';
  static const shaftTypeKey = 'shaft_type';
  static const mountKey = 'mount';

  Potentiometer({
    required super.id,
    required this.value,
    required this.taper,
    this.baseDiameter,
    this.shaftDiameter,
    this.shaftLength,
    this.shaftType,
    this.mount,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.potentiometer,
         attrs: {
           valueKey: value.toString(),
           taperKey: taper,
           sizeKey: baseDiameter,
           shaftDiameterKey: shaftDiameter,
           shaftLengthKey: shaftLength,
           shaftTypeKey: shaftType,
           mountKey: mount,
         },
       );

  final int value;
  final String taper;
  final String? baseDiameter;
  final String? shaftDiameter;
  final String? shaftLength;
  final String? shaftType;
  final String? mount;

  String get taperCode {
    switch (taper) {
      case 'Audio / Log (A)':
        return 'A';
      case 'Linear (B)':
        return 'B';
      case 'Reverse Audio (C)':
        return 'C';
      case 'W':
        return 'C';
      default:
        return taper;
    }
  }

  String get valueString {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    } else {
      return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
    }
  }

  String get code => '$taperCode$valueString';

  String get shaftString {
    return '$shaftType shaft';
  }

  @override
  String display() {
    var details = code;
    if (shaftType != null) {
      details = '$details $shaftString';
    }
    if (mount != null) {
      details = '$details $mount';
    }
    if (baseDiameter != null) {
      details = '$details $baseDiameter';
    }
    return details;
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Potentiometer &&
      value == other.value &&
      taper == other.taper &&
      baseDiameter == other.baseDiameter &&
      shaftDiameter == other.shaftDiameter &&
      shaftLength == other.shaftLength &&
      shaftType == other.shaftType &&
      mount == other.mount;

  @override
  int get hashCode => Object.hash(
    value,
    taper,
    baseDiameter,
    shaftDiameter,
    shaftLength,
    shaftType,
    mount,
  );

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    int value = this.value;
    String taper = this.taper;
    String? baseDiameter = this.baseDiameter;
    String? shaftDiameter = this.shaftDiameter;
    String? shaftLength = this.shaftLength;
    String? shaftType = this.shaftType;
    String? mount = this.mount;
    attrs.forEach((k, v) {
      switch (k) {
        case Potentiometer.valueKey:
          value = int.parse(v);
        case Potentiometer.taperKey:
          taper = v;
        case Potentiometer.sizeKey:
          baseDiameter = v;
        case Potentiometer.shaftDiameterKey:
          shaftDiameter = v;
        case Potentiometer.shaftLengthKey:
          shaftLength = v;
        case Potentiometer.shaftTypeKey:
          shaftType = v;
        case Potentiometer.mountKey:
          mount = v;
        default:
          debugPrint('unknown field $k');
      }
    });
    final update = Potentiometer(
      id: id,
      value: value,
      taper: taper,
      baseDiameter: baseDiameter,
      shaftDiameter: shaftDiameter,
      shaftLength: shaftLength,
      shaftType: shaftType,
      mount: mount,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Potentiometer(
      id: id,
      value: int.parse(attrs[Potentiometer.valueKey]),
      taper: attrs[Potentiometer.taperKey],
      baseDiameter: attrs[Potentiometer.sizeKey],
      shaftDiameter: attrs[Potentiometer.shaftDiameterKey],
      shaftLength: attrs[Potentiometer.shaftLengthKey],
      shaftType: attrs[Potentiometer.shaftTypeKey],
      mount: attrs[Potentiometer.mountKey],
    );
  }
}
