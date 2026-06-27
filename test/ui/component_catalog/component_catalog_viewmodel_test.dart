import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

void main() {
  group('ComponentCatalogViewModel tests', () {
    test('Getting components by type', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = ComponentCatalogViewModel(
        inventoryRepository: inventoryRepository,
      );

      expect(viewModel.components('Resistors').isEmpty, true);
      expect(viewModel.components('Diodes').isEmpty, true);

      inventoryRepository.addResistor(
        Resistor(value: '10 K', tolerance: '2%', power: '1/4 W'),
      );

      expect(viewModel.components('Resistors').length, 1);
      expect(viewModel.components('Diodes').isEmpty, true);

      inventoryRepository.addResistor(
        Resistor(value: '1 K', tolerance: '2%', power: '1/4 W'),
      );

      expect(viewModel.components('Resistors').length, 2);
      expect(viewModel.components('Diodes').isEmpty, true);

      inventoryRepository.addDiode(Diode(code: '1N34A'));

      expect(viewModel.components('Resistors').length, 2);
      expect(viewModel.components('Diodes').length, 1);
    });
  });
}
