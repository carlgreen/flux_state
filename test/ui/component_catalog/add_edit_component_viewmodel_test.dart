import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component_category.dart';
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
  });
}

class FalseComponent {
  set count(int count) {}
}
