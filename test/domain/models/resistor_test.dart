import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/domain/models/resistor.dart';

void main() {
  group('Resistor display tests', () {
    test('format resistor value', () {
      expect(formatResistorValue(10000), equals('10 Ω'));
      expect(formatResistorValue(1000000), equals('1 kΩ'));
      expect(formatResistorValue(1000000000), equals('1 MΩ'));
      expect(formatResistorValue(5100000000), equals('5.1 MΩ'));
    });

    test('format resistor tolerance', () {
      expect(formatResistorTolerance('2'), equals('± 2%'));
    });

    test('format resistor power rating', () {
      expect(formatResistorPowerRating('1/4'), equals('1/4 W'));
    });
  });

  group('plain numbers (no unit letter)', () {
    test('integer', () {
      expect(parseResistorValueMilliohms('100'), equals(100000));
    });

    test('decimal', () {
      expect(parseResistorValueMilliohms('4.1'), equals(4100));
    });
  });

  group('R = ohms', () {
    test('letter mid-string acts as the decimal point', () {
      expect(parseResistorValueMilliohms('4r1'), equals(4100));
      expect(parseResistorValueMilliohms('4R1'), equals(4100));
    });

    test('letter as a trailing unit suffix', () {
      expect(parseResistorValueMilliohms('100R'), equals(100000));
      expect(parseResistorValueMilliohms('100r'), equals(100000));
    });

    test('leading R implies a value under 1 ohm', () {
      expect(parseResistorValueMilliohms('R47'), equals(470));
      expect(parseResistorValueMilliohms('r47'), equals(470));
    });
  });

  group('k = kilo (x1,000)', () {
    test('letter mid-string acts as the decimal point', () {
      expect(parseResistorValueMilliohms('4k1'), equals(4100000));
      expect(parseResistorValueMilliohms('4K1'), equals(4100000));
    });

    test('explicit decimal point, letter as suffix', () {
      expect(parseResistorValueMilliohms('4.1k'), equals(4100000));
      expect(parseResistorValueMilliohms('4.1K'), equals(4100000));
    });

    test('letter as a bare trailing unit suffix', () {
      expect(parseResistorValueMilliohms('1k'), equals(1000000));
      expect(parseResistorValueMilliohms('1K'), equals(1000000));
    });
  });

  group('m/M = mega (x1,000,000)', () {
    test('letter mid-string acts as the decimal point', () {
      expect(parseResistorValueMilliohms('5m1'), equals(5100000000));
      expect(parseResistorValueMilliohms('5M1'), equals(5100000000));
    });

    test('explicit decimal point, letter as suffix', () {
      expect(parseResistorValueMilliohms('5.1m'), equals(5100000000));
      expect(parseResistorValueMilliohms('5.1M'), equals(5100000000));
    });

    test('letter as a bare trailing unit suffix', () {
      expect(parseResistorValueMilliohms('1m'), equals(1000000000));
      expect(parseResistorValueMilliohms('1M'), equals(1000000000));
    });
  });

  group('leniency', () {
    test('surrounding and internal whitespace is ignored', () {
      expect(parseResistorValueMilliohms('  4k1 '), equals(4100000));
      expect(parseResistorValueMilliohms('4 k 1'), equals(4100000));
    });

    test('comma is accepted as a decimal separator', () {
      expect(parseResistorValueMilliohms('4,1k'), equals(4100000));
    });

    test('trailing "ohm" / "ohms" / "Ω" unit text is stripped', () {
      expect(parseResistorValueMilliohms('100 ohm'), equals(100000));
      expect(parseResistorValueMilliohms('100 ohms'), equals(100000));
      expect(parseResistorValueMilliohms('100Ω'), equals(100000));
      expect(parseResistorValueMilliohms('4.1kΩ'), equals(4100000));
      expect(parseResistorValueMilliohms('1kΩ'), equals(1000000));
    });
  });

  group('invalid input throws FormatException', () {
    test('empty string', () {
      expect(() => parseResistorValueMilliohms(''), throwsFormatException);
    });

    test('non-numeric garbage', () {
      expect(() => parseResistorValueMilliohms('abc'), throwsFormatException);
    });

    test('a lone multiplier letter with no digits at all', () {
      expect(() => parseResistorValueMilliohms('k'), throwsFormatException);
    });
  });
}
