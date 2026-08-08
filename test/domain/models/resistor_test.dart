import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/domain/models/resistor.dart';

void main() {
  group('Resistor tests', () {
    test('format resistor value', () {
      expect(formatResistorValue(10), equals('10 Ω'));
      expect(formatResistorValue(1000), equals('1 kΩ'));
      expect(formatResistorValue(1000000), equals('1 MΩ'));
      expect(formatResistorValue(5100000), equals('5.1 MΩ'));
    });

    test('format resistor tolerance', () {
      expect(formatResistorTolerance('2'), equals('± 2%'));
    });

    test('format resistor power rating', () {
      expect(formatResistorPowerRating('1/4'), equals('1/4 W'));
    });
  });
}
