import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';

void main() {
  group('AddEditComponentViewModel tests', () {
    test('Create resistor', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      expect(inventoryRepository.resistors.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'value': '1000',
        'tolerance_pct': '10',
        'power_w': '500',
      }, 10);

      expect(inventoryRepository.resistors.length, 1);
      expect(inventoryRepository.resistors.first.quantity, 10);
      expect(inventoryRepository.diodes.isEmpty, true);
    });

    test('Update resistor', () {
      final inventoryRepository = InventoryRepository()
        ..addResistor(
          Resistor(
            id: 'a',
            value: 1000,
            tolerance: 2,
            power: 250,
            quantity: 10,
          ),
        );
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.update('a', <String, dynamic>{
        'value': '100',
        'tolerance_pct': '10',
        'power_w': '500',
      }, 5);

      expect(inventoryRepository.resistors.length, 1);
      expect(
        inventoryRepository.resistors.first,
        Resistor(id: 'a', value: 100, tolerance: 10, power: 500, quantity: 5),
      );
    });

    test('Create diode', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.category = ComponentCategory.diode;

      expect(inventoryRepository.diodes.isEmpty, true);

      viewModel.save(<String, dynamic>{'code': '1n34A'}, 5);

      expect(inventoryRepository.diodes.length, 1);
      expect(inventoryRepository.diodes.first.quantity, 5);
      expect(inventoryRepository.resistors.isEmpty, true);
    });

    test('Update didoe', () {
      final inventoryRepository = InventoryRepository()
        ..addDiode(Diode(id: 'c', code: 'abc', quantity: 5));
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.category = ComponentCategory.diode;

      viewModel.update('c', <String, dynamic>{'code': 'def'}, 50);

      expect(inventoryRepository.diodes.length, 1);
      expect(
        inventoryRepository.diodes.first,
        Diode(id: 'c', code: 'def', quantity: 50),
      );
    });
  });
}

class FalseComponent {
  set count(int count) {}
}
