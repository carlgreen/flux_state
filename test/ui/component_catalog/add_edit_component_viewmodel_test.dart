import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/domain/models/transistor.dart';
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
      expect(resistor.value, 1000000);
      expect(resistor.tolerance, null);
      expect(resistor.power, null);
      expect(resistor.material, null);
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
        'material': 'Metal Film',
        'package': 'Through-hole',
      }, 10);

      final resistor = inventoryRepository.components.single as Resistor;
      expect(resistor.value, 1000000);
      expect(resistor.tolerance, '10');
      expect(resistor.power, '0.5');
      expect(resistor.material, 'Metal Film');
      expect(resistor.package, 'Through-hole');
      expect(resistor.quantity, 10);
    });

    test('Update resistor', () {
      final inventoryRepository = InventoryRepository()
        ..addComponent(
          Resistor(
            id: 'a',
            value: 1000000,
            tolerance: '2',
            power: '0.25',
            material: 'Carbon Film',
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
        'material': 'Carbon Film',
        'package': 'SMD',
      }, 5);

      expect(
        inventoryRepository.components.single,
        Resistor(
          id: 'a',
          value: 100000,
          tolerance: '10',
          power: '0.5',
          material: 'Carbon Film',
          package: 'SMD',
          quantity: 5,
        ),
      );
    });

    test('Create capacitor with mimimal fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.category = ComponentCategory.capacitor;
      viewModel.save(<String, dynamic>{'value': '1u', 'polarised': false}, 10);

      final capacitor = inventoryRepository.components.single as Capacitor;
      expect(capacitor.value, 1000000);
      expect(capacitor.voltage, null);
      expect(capacitor.tolerance, null);
      expect(capacitor.material, null);
      expect(capacitor.polarised, false);
      expect(capacitor.quantity, 10);
    });

    test('Create capacitor with all fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.category = ComponentCategory.capacitor;
      viewModel.save(<String, dynamic>{
        'value': '1n5',
        'voltage_v': '50',
        'tolerance_pct': '10',
        'material': 'Tantalum',
        'polarised': true,
      }, 10);

      final capacitor = inventoryRepository.components.single as Capacitor;
      expect(capacitor.value, 1500);
      expect(capacitor.voltage, 50);
      expect(capacitor.tolerance, '10');
      expect(capacitor.material, 'Tantalum');
      expect(capacitor.polarised, true);
      expect(capacitor.quantity, 10);
    });

    test('Update capacitor', () {
      final inventoryRepository = InventoryRepository()
        ..addComponent(
          Capacitor(
            id: 'a',
            value: 1000,
            voltage: 50,
            tolerance: '2',
            polarised: false,
            quantity: 10,
          ),
        );
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.update('a', <String, dynamic>{
        'value': '100pF',
        'tolerance_pct': '10',
        'polarised': true,
        'material': 'Tantalum',
      }, 5);

      expect(
        inventoryRepository.components.single,
        Capacitor(
          id: 'a',
          value: 100,
          voltage: 50,
          tolerance: '10',
          material: 'Tantalum',
          polarised: true,
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

    test('Create transistor with mimimal fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.category = ComponentCategory.transistor;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{'part_number': '2N2222A'}, 10);

      final transistor = inventoryRepository.components.single as Transistor;
      expect(transistor.partNumber, '2N2222A');
      expect(transistor.partFamily, null);
      expect(transistor.type, null);
      expect(transistor.package, null);
      expect(transistor.quantity, 10);
    });

    test('Create transistor with all fields', () {
      final inventoryRepository = InventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.category = ComponentCategory.transistor;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'part_number': '2N2222A',
        'part_family': '2N2222',
        'type': 'NPN',
        'package': 'TO-18',
      }, 10);

      final transistor = inventoryRepository.components.single as Transistor;
      expect(transistor.partNumber, '2N2222A');
      expect(transistor.partFamily, '2N2222');
      expect(transistor.type, 'NPN');
      expect(transistor.package, 'TO-18');
      expect(transistor.quantity, 10);
    });

    test('Update transistor', () {
      final inventoryRepository = InventoryRepository()
        ..addComponent(
          Transistor(
            id: 'a',
            partNumber: '2N2222A',
            partFamily: '2N2222',
            type: 'NPN',
            package: 'TO-18',
            quantity: 10,
          ),
        );
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
        initialCategory: ComponentCategory.transistor,
      );

      viewModel.category = ComponentCategory.transistor;

      viewModel.update('a', <String, dynamic>{
        'part_number': '2N2222',
        'part_family': null,
        'type': 'NPN',
        'package': 'TO-92',
      }, 5);

      expect(
        inventoryRepository.components.single,
        Transistor(
          id: 'a',
          partNumber: '2N2222',
          partFamily: null,
          type: 'NPN',
          package: 'TO-92',
          quantity: 5,
        ),
      );
    });
  });
}
