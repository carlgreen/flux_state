import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';

enum AttributeFieldType { text, number, dropdown, boolean }

class AttributeField {
  final String key;
  final String label;
  final AttributeFieldType type;
  final List<String>? options;
  final String? unit;
  final bool required;
  final String? hint;

  AttributeField({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.unit,
    this.required = false,
    this.hint,
  });
}

class ComponentSchemas {
  ComponentSchemas._();

  static List<AttributeField> forCategory(ComponentCategory category) {
    return switch (category) {
      ComponentCategory.resistor => [
        AttributeField(
          key: Resistor.valueKey,
          label: 'Value',
          type: AttributeFieldType.text,
          required: true,
          hint: '10k, 4.7k, 1M',
        ),
        AttributeField(
          key: Resistor.toleranceKey,
          label: 'Tolerance',
          type: AttributeFieldType.dropdown,
          unit: '%',
          options: ['0.1', '0.5', '1', '2', '5', '10', '20'],
        ),
        AttributeField(
          key: Resistor.powerKey,
          label: 'Power',
          type: AttributeFieldType.dropdown,
          unit: 'W',
          options: ['0.1', '0.125', '0.25', '0.5', '1', '2', '5'],
        ),
        AttributeField(
          key: Resistor.materialKey,
          label: 'Material',
          type: AttributeFieldType.dropdown,
          options: ['Metal Film', 'Carbon Film'],
        ),
        AttributeField(
          key: Resistor.packageKey,
          label: 'Package',
          type: AttributeFieldType.dropdown,
          options: ['Through-hole', '0402', '0603', '0805', '1206', '1210'],
        ),
      ],
      ComponentCategory.capacitor => [
        AttributeField(
          key: Capacitor.valueKey,
          label: 'Value',
          type: AttributeFieldType.text,
          required: true,
          hint: '100n, 10u, 47p',
        ),
        AttributeField(
          key: Capacitor.voltageKey,
          label: 'Voltage Rating',
          type: AttributeFieldType.number,
          unit: 'V',
        ),
        AttributeField(
          key: Capacitor.toleranceKey,
          label: 'Tolerance',
          type: AttributeFieldType.dropdown,
          unit: '%',
          options: ['5', '10', '20'],
        ),
        AttributeField(
          // key: 'material',
          key: Capacitor.materialKey,
          label: 'Type / Dielectric',
          type: AttributeFieldType.dropdown,
          options: [
            'Ceramic (MLCC)',
            'Electrolytic',
            'Film (Polyester)',
            'Film (Polypropylene)',
            'Tantalum',
            'Silver Mica',
          ],
        ),
        AttributeField(
          key: Capacitor.polarisedKey,
          label: 'Polarised',
          type: AttributeFieldType.boolean,
          required: true,
        ),
      ],
      ComponentCategory.diode => [
        AttributeField(
          key: Diode.partNumberKey,
          label: 'Part Number',
          type: AttributeFieldType.text,
          required: true,
          hint: '1N4148, 1N4001, BZX55C5V1',
        ),
        AttributeField(
          key: Diode.materialKey,
          label: 'Material',
          type: AttributeFieldType.dropdown,
          options: ['Silicon', 'Germanium'],
        ),
        AttributeField(
          key: Diode.packageKey,
          label: 'Package',
          type: AttributeFieldType.dropdown,
          options: [
            'DO-35',
            'DO-41',
            'SOD-123',
            'SOD-323',
            'SMA',
            'SMB',
            'Other',
          ],
        ),
      ],
      ComponentCategory.led => [
        AttributeField(
          key: 'colour',
          label: 'Colour',
          type: AttributeFieldType.dropdown,
          required: true,
          options: [
            'Red',
            'Green',
            'Yellow',
            'Orange',
            'Blue',
            'White',
            'UV',
            'RGB',
            'IR',
            'Other',
          ],
        ),
        AttributeField(
          key: 'size_mm',
          label: 'Size',
          type: AttributeFieldType.dropdown,
          required: true,
          options: [
            '2mm',
            '3mm',
            '5mm',
            '10mm',
            'SMD 0603',
            'SMD 0805',
            'Other',
          ],
        ),
        AttributeField(
          key: 'forward_v',
          label: 'Forward Voltage',
          type: AttributeFieldType.number,
          unit: 'V',
        ),
        AttributeField(
          key: 'current_ma',
          label: 'Typical Current',
          type: AttributeFieldType.number,
          unit: 'mA',
        ),
        AttributeField(
          key: 'lens',
          label: 'Lens',
          type: AttributeFieldType.dropdown,
          options: ['Clear', 'Diffused', 'Water Clear', 'Tinted'],
        ),
      ],
    };
  }
}
