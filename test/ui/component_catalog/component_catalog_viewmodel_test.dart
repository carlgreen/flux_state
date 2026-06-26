import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

void main() {
  group('ComponentCatalogViewModel tests', () {
    test('Create resistor', () {
      final viewModel = ComponentCatalogViewModel(
        inventoryRepository: InventoryRepository(),
      );

      expect(viewModel.resistors.isEmpty, true);

      viewModel.add('Resistors');

      expect(viewModel.resistors.isNotEmpty, true);
      expect(viewModel.diodes.isEmpty, true);
    });

    test('Create diode', () {
      final viewModel = ComponentCatalogViewModel(
        inventoryRepository: InventoryRepository(),
      );

      expect(viewModel.diodes.isEmpty, true);

      viewModel.add('Diodes');

      expect(viewModel.diodes.isNotEmpty, true);
      expect(viewModel.resistors.isEmpty, true);
    });

    test('Create invalid does nothing', () {
      final viewModel = ComponentCatalogViewModel(
        inventoryRepository: InventoryRepository(),
      );

      viewModel.add('xyz');

      expect(viewModel.resistors.isEmpty, true);
      expect(viewModel.diodes.isEmpty, true);
    });
  });
}
