import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/domain/models/capacitor.dart';

void main() {
  group('Capacitor display tests', () {
    test('format capacitor value', () {
      expect(formatCapacitorValue(10), equals('10 pF'));
      expect(formatCapacitorValue(1500), equals('1.5 nF'));
      expect(formatCapacitorValue(10000), equals('10 nF'));
      expect(formatCapacitorValue(1500000), equals('1.5 μF'));
      expect(formatCapacitorValue(10000000), equals('10 μF'));
      expect(formatCapacitorValue(1500000000), equals('1.5 mF'));
      expect(formatCapacitorValue(10000000000), equals('10 mF'));
    });
  });

  group('plain numbers (no unit letter)', () {
    test('integer', () {
      expect(parseCapacitorValuePicofarads('1'), equals(1000000000000));
    });

    test('decimal', () {
      expect(parseCapacitorValuePicofarads('5.1'), equals(5100000000000));
    });
  });

  group('m = milli (x0.001)', () {
    test('letter mid-string acts as the decimal point', () {
      expect(parseCapacitorValuePicofarads('4m1'), equals(4100000000));
      expect(parseCapacitorValuePicofarads('4M1'), equals(4100000000));
    });

    test('explicit decimal point, letter as suffix', () {
      expect(parseCapacitorValuePicofarads('4.1m'), equals(4100000000));
      expect(parseCapacitorValuePicofarads('4.1M'), equals(4100000000));
    });

    test('letter as a bare trailing unit suffix', () {
      expect(parseCapacitorValuePicofarads('1m'), equals(1000000000));
      expect(parseCapacitorValuePicofarads('1M'), equals(1000000000));
    });
  });

  group('μ = micro (x0.000,001)', () {
    test('letter mid-string acts as the decimal point', () {
      expect(parseCapacitorValuePicofarads('5μ1'), equals(5100000));
      expect(parseCapacitorValuePicofarads('5u1'), equals(5100000));
      expect(parseCapacitorValuePicofarads('5U1'), equals(5100000));
    });

    test('explicit decimal point, letter as suffix', () {
      expect(parseCapacitorValuePicofarads('5.1μ'), equals(5100000));
      expect(parseCapacitorValuePicofarads('5.1u'), equals(5100000));
      expect(parseCapacitorValuePicofarads('5.1U'), equals(5100000));
    });

    test('letter as a bare trailing unit suffix', () {
      expect(parseCapacitorValuePicofarads('1μ'), equals(1000000));
      expect(parseCapacitorValuePicofarads('1u'), equals(1000000));
      expect(parseCapacitorValuePicofarads('1U'), equals(1000000));
    });
  });

  group('n = micro (x0.000,000,001)', () {
    test('letter mid-string acts as the decimal point', () {
      expect(parseCapacitorValuePicofarads('5n1'), equals(5100));
      expect(parseCapacitorValuePicofarads('5N1'), equals(5100));
    });

    test('explicit decimal point, letter as suffix', () {
      expect(parseCapacitorValuePicofarads('5.1n'), equals(5100));
      expect(parseCapacitorValuePicofarads('5.1N'), equals(5100));
    });

    test('letter as a bare trailing unit suffix', () {
      expect(parseCapacitorValuePicofarads('1n'), equals(1000));
      expect(parseCapacitorValuePicofarads('1N'), equals(1000));
    });
  });

  group('p = pico (x0.000,000,000,001)', () {
    test('letter mid-string acts as the decimal point', () {
      expect(parseCapacitorValuePicofarads('5p1'), equals(5));
      expect(parseCapacitorValuePicofarads('5P1'), equals(5));
    });

    test('explicit decimal point, letter as suffix', () {
      expect(parseCapacitorValuePicofarads('5.1p'), equals(5));
      expect(parseCapacitorValuePicofarads('5.1P'), equals(5));
    });

    test('letter as a bare trailing unit suffix', () {
      expect(parseCapacitorValuePicofarads('1p'), equals(1));
      expect(parseCapacitorValuePicofarads('1P'), equals(1));
    });
  });

  group('leniency', () {
    test('surrounding and internal whitespace is ignored', () {
      expect(parseCapacitorValuePicofarads('  4n1 '), equals(4100));
      expect(parseCapacitorValuePicofarads('4 n 1'), equals(4100));
    });

    test('comma is accepted as a decimal separator', () {
      expect(parseCapacitorValuePicofarads('4,1n'), equals(4100));
    });

    test('trailing "f" unit text is stripped', () {
      expect(parseCapacitorValuePicofarads('4.1nf'), equals(4100));
    });
  });

  group('invalid input throws FormatException', () {
    test('empty string', () {
      expect(() => parseCapacitorValuePicofarads(''), throwsFormatException);
    });

    test('non-numeric garbage', () {
      expect(() => parseCapacitorValuePicofarads('abc'), throwsFormatException);
    });

    test('a lone multiplier letter with no digits at all', () {
      expect(() => parseCapacitorValuePicofarads('μ'), throwsFormatException);
    });
  });
}
