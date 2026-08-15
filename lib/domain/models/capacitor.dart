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
           valueKey: formatCapacitorValue(value),
           voltageKey: voltage ?? '',
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

  String get valueString => formatCapacitorValue(value);
  String get voltageString =>
      voltage != null ? formatCapacitorVoltage(voltage!) : '';
  String get toleranceString =>
      tolerance != null ? formatCapacitorTolerance(tolerance!) : '';

  @override
  String display() {
    var main = valueString;
    if (polarised) {
      main = '$main polarised';
    }
    if (voltage != null) {
      main = '$main $voltageString';
    }
    if (tolerance != null) {
      main = '$main $toleranceString';
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
    attrs.forEach((k, v) {
      switch (k) {
        case Capacitor.valueKey:
          value = parseCapacitorValuePicofarads(v);
        case Capacitor.voltageKey:
          voltage = v != '' ? int.parse(v) : null;
        case Capacitor.toleranceKey:
          tolerance = v;
        case Capacitor.materialKey:
          material = v;
        case Capacitor.polarisedKey:
          // this is already parsed from it being a switch input
          polarised = v;
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
    return Capacitor(
      id: id,
      value: parseCapacitorValuePicofarads(attrs[Capacitor.valueKey]),
      voltage: attrs[Capacitor.voltageKey] != null
          ? int.parse(attrs[Capacitor.voltageKey])
          : null,
      tolerance: attrs[Capacitor.toleranceKey],
      material: attrs[Capacitor.materialKey],
      polarised: attrs[Capacitor.polarisedKey] ?? false,
    );
  }
}

/// Converts picofarads to nano, micro, or milli, before
/// dropping decimal places if they are zero.
String formatCapacitorValue(int value) {
  if (value >= 1_000_000_000_000) {
    return '${(value / 1_000_000_000_000).toStringAsFixed(value % 1_000_000_000_000 == 0 ? 0 : 1)} F';
  } else if (value >= 1_000_000_000) {
    return '${(value / 1_000_000_000).toStringAsFixed(value % 1_000_000_000 == 0 ? 0 : 1)} mF';
  } else if (value >= 1_000_000) {
    return '${(value / 1_000_000).toStringAsFixed(value % 1_000_000 == 0 ? 0 : 1)} μF';
  } else if (value >= 1_000) {
    return '${(value / 1_000).toStringAsFixed(value % 1_000 == 0 ? 0 : 1)} nF';
  } else {
    return '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)} pF';
  }
}

String formatCapacitorVoltage(int value) {
  return '$value V';
}

String formatCapacitorTolerance(String tolerance) {
  return '± $tolerance%';
}

/// Parses a capacitor value where the multiplier letter (p, n, μ, m) can
/// replace decimal point (e.g. "5u1" == "5.1u" == 5.1 μF).
///
/// Returns the value in picofarads and assumes that this can be an
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
/// Also assumes uppercase 'M' to be the same as lowercase 'm', both
/// milli, as megafarad capacitors are not likely.
///
/// Throws a [FormatException] if the string cannot be parsed.
int parseCapacitorValuePicofarads(String input) {
  var s = input.trim();
  if (s.isEmpty) {
    throw FormatException('Empty capacitor value', input);
  }

  // Strip all whitespace
  s = s.replaceAll(RegExp(r'\s+'), '');

  // Strip a trailing unit word/symbol, if present
  s = s.replaceAll(RegExp(r'(farads?|F)$', caseSensitive: false), '');

  // Some places use commas for the decimal place?
  s = s.replaceAll(',', '.');

  if (s.isEmpty) {
    throw FormatException('Empty capacitor value', input);
  }

  const multipliers = <String, double>{
    'f': 1000_000_000_000,
    'F': 1000_000_000_000,
    'm': 1000_000_000,
    'M': 1000_000_000,
    'μ': 1000_000,
    'u': 1000_000,
    'U': 1000_000,
    'n': 1000,
    'N': 1000,
    'p': 1,
    'P': 1,
  };

  // Find the first multiplier letter in the string, if any.
  var multIndex = -1;
  for (var i = 0; i < s.length; i++) {
    if (multipliers.containsKey(s[i])) {
      multIndex = i;
      break;
    }
  }

  // No multiplier letter -> plain decimal number, e.g. "100", "4.1",
  // so i guess farads?
  if (multIndex == -1) {
    final value = double.tryParse(s);
    if (value == null) {
      throw FormatException('Could not parse capacitor value', input);
    }
    return (value * 1000_000_000_000).round();
  }

  final multiplier = multipliers[s[multIndex]]!;
  final before = s.substring(0, multIndex);
  final after = s.substring(multIndex + 1);

  final String numeric;
  if (after.isEmpty) {
    // Letter is a trailing unit suffix, e.g. "100n", "1u" -- nothing
    // follows it, so it doesn't stand in for a decimal point.
    numeric = before;
  } else {
    // Letter acts as the decimal point, e.g. "4n1" -> "4.1",
    // "n47" -> "0.47" (nothing before the letter implies a leading 0).
    numeric = '${before.isEmpty ? '0' : before}.$after';
  }

  if (numeric.isEmpty) {
    throw FormatException('Could not parse capacitor value', input);
  }

  final value = double.tryParse(numeric);
  if (value == null) {
    throw FormatException('Could not parse capacitor value', input);
  }

  return (value * multiplier).round();
}
