import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Resistor extends Component {
  static const valueKey = 'value';
  static const toleranceKey = 'tolerance_pct';
  static const powerKey = 'power_w';
  static const materialKey = 'material';
  static const packageKey = 'package';

  Resistor({
    required super.id,
    required this.value,
    this.tolerance,
    this.power,
    this.material,
    this.package,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.resistor,
         attrs: {
           valueKey: (value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1),
           toleranceKey: tolerance,
           powerKey: power,
           materialKey: material,
           packageKey: package,
         },
       );

  /// milliohms so that it can be an integer
  final int value;
  final String? tolerance;
  final String? power;
  final String? material;
  final String? package;

  String get valueString => formatResistorValue(value);
  String get powerString =>
      power != null ? formatResistorPowerRating(power!) : '';
  String get toleranceString =>
      tolerance != null ? formatResistorTolerance(tolerance!) : '';
  String get materialString => material != null ? '$material' : '';
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
    if (material != null) {
      value = '$value $materialString';
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
      material == other.material &&
      package == other.package &&
      quantity == other.quantity;

  @override
  int get hashCode =>
      Object.hash(value, tolerance, power, material, package, quantity);

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    int value = this.value;
    String? tolerance = this.tolerance;
    String? power = this.power;
    String? material = this.material;
    String? package = this.package;
    attrs.forEach((k, v) {
      switch (k) {
        case Resistor.valueKey:
          value = parseResistorValueMilliohms(v);
        case Resistor.toleranceKey:
          tolerance = v;
        case Resistor.powerKey:
          power = v;
        case Resistor.materialKey:
          material = v;
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
      material: material,
      package: package,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Resistor(
      id: id,
      value: parseResistorValueMilliohms(attrs[Resistor.valueKey]),
      tolerance: attrs[Resistor.toleranceKey],
      power: attrs[Resistor.powerKey],
      material: attrs[Resistor.materialKey],
      package: attrs[Resistor.packageKey],
    );
  }
}

/// Converts milliohms to ohms, then to M or k if large enough, before
/// dropping decimal places if they are zero.
String formatResistorValue(int milliohmsValue) {
  var value = milliohmsValue / 1000;
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)} MΩ';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)} kΩ';
  } else {
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)} Ω';
  }
}

String formatResistorPowerRating(String value) {
  return '$value W';
}

String formatResistorTolerance(String tolerance) {
  return '± $tolerance%';
}

/// Parses a resistor value where the multiplier letter (R, k, M) can
/// replace decimal point (e.g. "4k7" == "4.7k" == 4700 ohms).
///
/// Returns the value in milliohms and assumes that this can be an
/// integer.
///
/// Supported forms (case-insensitive, whitespace-tolerant):
///   - Plain numbers:        "100"     -> 100000    (100 ohms)
///                           "4.1"     -> 4100      (4.1 ohms)
///   - R (ohms) as unit:     "4r1"     -> 4100
///                           "100R"    -> 100000
///                           "R47"     -> 470       (leading R => < 1 ohm)
///   - k (kilo, x1000):      "4k1"     -> 4100000
///                           "4.1k"    -> 4100000
///                           "1k"      -> 1000000
///   - m/M (mega, x1000000): "5m1"     -> 5100000000
///                           "5.1M"    -> 5100000000
///   - Optional trailing unit word: "100 ohm", "4.7kΩ", "1kΩ"
///   - Comma as decimal separator: "4,7k" -> 4700000
///   - Stray internal/external whitespace: " 4 k 7 " -> 4700000
///
/// Also assumes lowercase 'm' to be the same as uppercase 'M', both
/// mega, as milliohm resistors are rare and are normally written
/// explicitly (e.g. "0.001R").
///
/// Throws a [FormatException] if the string cannot be parsed.
int parseResistorValueMilliohms(String input) {
  var s = input.trim();
  if (s.isEmpty) {
    throw FormatException('Empty resistor value', input);
  }

  // Strip all whitespace
  s = s.replaceAll(RegExp(r'\s+'), '');

  // Strip a trailing unit word/symbol, if present
  s = s.replaceAll(RegExp(r'(ohms?|Ω)$', caseSensitive: false), '');

  // Some places use commas for the decimal place?
  s = s.replaceAll(',', '.');

  if (s.isEmpty) {
    throw FormatException('Empty resistor value', input);
  }

  const multipliers = <String, double>{
    'r': 1,
    'R': 1,
    'k': 1000,
    'K': 1000,
    'm': 1000000,
    'M': 1000000,
  };

  // Find the first multiplier letter in the string, if any.
  var multIndex = -1;
  for (var i = 0; i < s.length; i++) {
    if (multipliers.containsKey(s[i])) {
      multIndex = i;
      break;
    }
  }

  // No multiplier letter -> plain decimal number, e.g. "100", "4.1".
  if (multIndex == -1) {
    final value = double.tryParse(s);
    if (value == null) {
      throw FormatException('Could not parse resistor value', input);
    }
    return (value * 1000).round();
  }

  final multiplier = multipliers[s[multIndex]]!;
  final before = s.substring(0, multIndex);
  final after = s.substring(multIndex + 1);

  final String numeric;
  if (after.isEmpty) {
    // Letter is a trailing unit suffix, e.g. "100k", "1M" -- nothing
    // follows it, so it doesn't stand in for a decimal point.
    numeric = before;
  } else {
    // Letter acts as the decimal point, e.g. "4k1" -> "4.1",
    // "R47" -> "0.47" (nothing before the letter implies a leading 0).
    numeric = '${before.isEmpty ? '0' : before}.$after';
  }

  if (numeric.isEmpty) {
    throw FormatException('Could not parse resistor value', input);
  }

  final value = double.tryParse(numeric);
  if (value == null) {
    throw FormatException('Could not parse resistor value', input);
  }

  return (value * multiplier * 1000).round();
}
