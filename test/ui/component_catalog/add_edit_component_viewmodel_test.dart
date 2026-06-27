import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';

void main() {
  group('AddEditComponentViewModel tests', () {
    test('Create resistor', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        componentType: 'Resistors',
        inventoryRepository: inventoryRepository,
      );

      expect(inventoryRepository.resistors.isEmpty, true);

      viewModel.save(
        Resistor(value: '1 K', tolerance: '10 %', power: '1/2 W'),
        10,
      );

      expect(inventoryRepository.resistors.length, 1);
      expect(inventoryRepository.resistors.first.count, 10);
      expect(inventoryRepository.diodes.isEmpty, true);
    });

    test('Create diode', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        componentType: 'Diodes',
        inventoryRepository: inventoryRepository,
      );

      expect(inventoryRepository.diodes.isEmpty, true);

      viewModel.save(Diode(code: '1n34A'), 5);

      expect(inventoryRepository.diodes.length, 1);
      expect(inventoryRepository.diodes.first.count, 5);
      expect(inventoryRepository.resistors.isEmpty, true);
    });

    test('Create invalid does nothing', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        componentType: 'xyz',
        inventoryRepository: InventoryRepository(),
      );

      viewModel.save(FalseComponent(), 1);

      expect(inventoryRepository.resistors.isEmpty, true);
      expect(inventoryRepository.diodes.isEmpty, true);
    });
  });
}

class FalseComponent {
  set count(int count) {}
}
