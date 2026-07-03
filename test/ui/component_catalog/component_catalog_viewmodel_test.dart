import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component_category.dart';
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

      expect(viewModel.components(ComponentCategory.resistor).isEmpty, true);
      expect(viewModel.components(ComponentCategory.diode).isEmpty, true);

      inventoryRepository.addResistor(
        Resistor(value: 10000, tolerance: 2, power: 250),
      );

      expect(viewModel.components(ComponentCategory.resistor).length, 1);
      expect(viewModel.components(ComponentCategory.diode).isEmpty, true);

      inventoryRepository.addResistor(
        Resistor(value: 1000, tolerance: 2, power: 250),
      );

      expect(viewModel.components(ComponentCategory.resistor).length, 2);
      expect(viewModel.components(ComponentCategory.diode).isEmpty, true);

      inventoryRepository.addDiode(Diode(code: '1N34A'));

      expect(viewModel.components(ComponentCategory.resistor).length, 2);
      expect(viewModel.components(ComponentCategory.diode).length, 1);
    });
  });
}
