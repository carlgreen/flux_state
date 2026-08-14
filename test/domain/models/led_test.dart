import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/domain/models/led.dart';

void main() {
  group('LED tests', () {
    test('update from attributes', () {
      var led = Led(id: 'abc', colour: 'Red', size: '5mm');
      var updatedLed =
          led.updateFromAttrs({
                'colour': 'Blue',
                'size_mm': '10mm',
                'forward_v': '1',
                'current_ma': '2',
                'lens': 'Tinted',
              })
              as Led;

      expect(
        updatedLed,
        equals(
          Led(
            id: 'abc',
            colour: 'Blue',
            size: '10mm',
            forwardVoltage: 1,
            current: 2,
            lens: 'Tinted',
          ),
        ),
      );
    });

    test('create from attributes', () {
      var led = Led.fromAttrs('def', {
        'colour': 'Blue',
        'size_mm': '10mm',
        'forward_v': '1',
        'current_ma': '2',
        'lens': 'Tinted',
      });
      expect(
        led,
        equals(
          Led(
            id: 'def',
            colour: 'Blue',
            size: '10mm',
            forwardVoltage: 1,
            current: 2,
            lens: 'Tinted',
          ),
        ),
      );
    });
  });
}
