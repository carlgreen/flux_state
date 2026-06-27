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
      expect(formatResistorTolerance(1), equals('± 1%'));
      expect(formatResistorTolerance(2), equals('± 2%'));
      expect(formatResistorTolerance(5), equals('± 5%'));
      expect(formatResistorTolerance(10), equals('± 10%'));
    });

    test('format resistor power rating', () {
      expect(formatResistorPowerRating(125), equals('1/8 W'));
      expect(formatResistorPowerRating(250), equals('1/4 W'));
      expect(formatResistorPowerRating(500), equals('1/2 W'));
      expect(formatResistorPowerRating(1000), equals('1 W'));
      expect(formatResistorPowerRating(2500), equals('2 1/2 W'));
      expect(formatResistorPowerRating(2000), equals('2 W'));
    });
  });
}
