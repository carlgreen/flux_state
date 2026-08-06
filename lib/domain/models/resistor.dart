import 'component.dart';
import 'component_category.dart';

class Resistor extends Component {
  static const valueKey = 'value';
  static const toleranceKey = 'tolerance_pct';
  static const powerKey = 'power_w';

  Resistor({
    required super.id,
    required this.value,
    required this.tolerance,
    required this.power,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.resistor,
         attrs: {valueKey: value, toleranceKey: tolerance, powerKey: power},
       );

  final int value;
  final int tolerance;
  final int power;

  String get valueString => formatResistorValue(value);
  String get powerString => formatResistorPowerRating(power);
  String get toleranceString => formatResistorTolerance(tolerance);

  @override
  String display() {
    return '$valueString $powerString ($toleranceString)';
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
      quantity == other.quantity;

  @override
  int get hashCode => Object.hash(value, tolerance, power, quantity);
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

String formatResistorPowerRating(int value) {
  final actualValue = value / 1000;
  if (actualValue == actualValue.toInt()) {
    return '${actualValue.round()} W';
  } else if (actualValue > 1) {
    return '${actualValue.toInt()} ${_doubleToFraction(actualValue - actualValue.toInt())} W';
  } else {
    return '${_doubleToFraction(actualValue)} W';
  }
}

String formatResistorTolerance(int tolerance) {
  final percent = tolerance * 1.0;
  final isWhole = percent == percent.roundToDouble();
  return '± ${isWhole ? percent.toInt() : percent}%';
}

// blindly copied from https://stackoverflow.com/a/5128558
String _doubleToFraction(double value, {double error = 0.000001}) {
  final n = value.floor().toInt();
  final x = value - n;
  if (x < error) {
    return '$n';
  } else if (1 - error < x) {
    return '${n + 1}';
  }

  // The lower fraction is 0/1
  var lowerN = 0;
  var lowerD = 1;
  // The upper fraction is 1/1
  var upperN = 1;
  var upperD = 1;
  while (true) {
    // The middle fraction is (lower_n + upper_n) / (lower_d + upper_d)
    final middleN = lowerN + upperN;
    final middleD = lowerD + upperD;
    // If x + error < middle
    if (middleD * (x + error) < middleN) {
      // middle is our new upper
      upperN = middleN;
      upperD = middleD;
      // Else If middle < x - error
    } else if (middleN < (x - error) * middleD) {
      // middle is our new lower
      lowerN = middleN;
      lowerD = middleD;
      // # Else middle is our best fraction
    } else {
      // return (n * middle_d + middle_n, middle_d)
      return '${n * middleD + middleN}/$middleD';
    }
  }
}
