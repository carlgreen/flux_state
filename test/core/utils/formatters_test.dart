import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/core/utils/formatters.dart';

void main() {
  group('Formatter tests', () {
    test('format quantity', () {
      expect(Formatters.quantity(10), equals('10'));
      expect(Formatters.quantity(1000), equals('1,000'));
      expect(Formatters.quantity(10000), equals('10,000'));
      expect(Formatters.quantity(1000000), equals('1,000,000'));
    });
  });
}
