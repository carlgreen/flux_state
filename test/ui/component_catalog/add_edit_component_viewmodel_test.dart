import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';

void main() {
  group('AddEditComponentViewModel tests', () {
    test('Create resistor with mimimal fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{'value': '1000'}, 10);

      final resistor = inventoryRepository.components.single as Resistor;
      expect(resistor.value, 1000);
      expect(resistor.tolerance, null);
      expect(resistor.power, null);
      expect(resistor.package, null);
      expect(resistor.quantity, 10);
    });

    test('Create resistor with all fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'value': '1000',
        'tolerance_pct': '10',
        'power_w': '0.5',
        'package': 'Through-hole',
      }, 10);

      final resistor = inventoryRepository.components.single as Resistor;
      expect(resistor.value, 1000);
      expect(resistor.tolerance, '10');
      expect(resistor.power, '0.5');
      expect(resistor.package, 'Through-hole');
      expect(resistor.quantity, 10);
    });

    test('Update resistor', () {
      final inventoryRepository = InventoryRepository()
        ..addComponent(
          Resistor(
            id: 'a',
            value: 1000,
            tolerance: '2',
            power: '0.25',
            quantity: 10,
          ),
        );
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.update('a', <String, dynamic>{
        'value': '100',
        'tolerance_pct': '10',
        'power_w': '0.5',
        'package': 'SMD',
      }, 5);

      expect(
        inventoryRepository.components.single,
        Resistor(
          id: 'a',
          value: 100,
          tolerance: '10',
          power: '0.5',
          package: 'SMD',
          quantity: 5,
        ),
      );
    });

    test('Create diode with minimal fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.category = ComponentCategory.diode;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{'part_number': '1n34A'}, 5);

      final diode = inventoryRepository.components.single as Diode;
      expect(diode.partNumber, '1n34A');
      expect(diode.material, null);
      expect(diode.package, null);
      expect(diode.quantity, 5);
    });

    test('Create diode with all fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.category = ComponentCategory.diode;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'part_number': '1n34A',
        'material': 'Germanium',
        'package': 'DO-41',
      }, 5);

      final diode = inventoryRepository.components.single as Diode;
      expect(diode.partNumber, '1n34A');
      expect(diode.material, 'Germanium');
      expect(diode.package, 'DO-41');
      expect(diode.quantity, 5);
    });

    test('Update didoe', () {
      final inventoryRepository = InventoryRepository()
        ..addComponent(Diode(id: 'c', partNumber: 'abc', quantity: 5));
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.category = ComponentCategory.diode;

      viewModel.update('c', <String, dynamic>{
        'part_number': 'def',
        'material': 'Silicon',
      }, 50);

      expect(
        inventoryRepository.components.single,
        Diode(id: 'c', partNumber: 'def', material: 'Silicon', quantity: 50),
      );
    });
  });
}
