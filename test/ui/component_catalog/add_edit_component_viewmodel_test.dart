import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/domain/models/switch.dart';
import 'package:flux_state/domain/models/transistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';

import '../../data/repositories/in_memory_inventory_repository.dart';

void main() {
  group('AddEditComponentViewModel tests', () {
    test('Create resistor with minimal fields', () {
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository()
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

    test('Create capacitor with minimal fields', () {
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository()
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
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository()
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

    test('Create transistor with minimal fields', () {
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository();
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
      final inventoryRepository = InMemoryInventoryRepository()
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

    test('Create toggle switch with minimal fields', () {
      final inventoryRepository = InMemoryInventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );
      viewModel.category = ComponentCategory.switchComp;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'type': 'Toggle',
        'poles': 2,
        'switching': 'On-On',
      }, 10);

      final toggleSw = inventoryRepository.components.single as Switch;
      expect(toggleSw.type, 'Toggle');
      expect(toggleSw.poles, 2);
      expect(toggleSw.switching, 'On-On');
      expect(toggleSw.positions, null);
      expect(toggleSw.momentary, false);
      expect(toggleSw.toggleSize, null);
      expect(toggleSw.bodySize, null);
      expect(toggleSw.shaftDiameter, null);
      expect(toggleSw.shaftType, null);
      expect(toggleSw.mount, null);
      expect(toggleSw.led, null);
      expect(toggleSw.quantity, 10);
    });

    test('Create toggle switch with all fields', () {
      final inventoryRepository = InMemoryInventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );
      viewModel.category = ComponentCategory.switchComp;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'type': 'Toggle',
        'poles': 1,
        'switching': 'On-Off-On',
        'momentary': true,
        'toggle_size': 'Micro',
        'mount': 'Lugs',
      }, 10);

      final toggleSw = inventoryRepository.components.single as Switch;
      expect(toggleSw.type, 'Toggle');
      expect(toggleSw.poles, 1);
      expect(toggleSw.switching, 'On-Off-On');
      expect(toggleSw.positions, null);
      expect(toggleSw.momentary, true);
      expect(toggleSw.toggleSize, 'Micro');
      expect(toggleSw.bodySize, null);
      expect(toggleSw.shaftDiameter, null);
      expect(toggleSw.shaftType, null);
      expect(toggleSw.mount, 'Lugs');
      expect(toggleSw.led, null);
      expect(toggleSw.quantity, 10);
    });

    test('Update toggle switch', () {
      final inventoryRepository = InMemoryInventoryRepository()
        ..addComponent(
          Switch(
            id: 'a',
            type: 'Toggle',
            poles: 1,
            switching: 'On-Off-On',
            momentary: true,
            toggleSize: 'Micro',
            mount: 'Lugs',
          ),
        );
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.update('a', <String, dynamic>{
        'poles': '2',
        'switching': 'On-On',
        'momentary': false,
        'toggle_size': null,
        'mount': null,
      }, 5);

      expect(
        inventoryRepository.components.single,
        Switch(
          id: 'a',
          type: 'Toggle',
          poles: 2,
          switching: 'On-On',
          momentary: false,
          toggleSize: null,
          mount: null,
          quantity: 5,
        ),
      );
    });

    test('Create rotary switch with minimal fields', () {
      final inventoryRepository = InMemoryInventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );
      viewModel.category = ComponentCategory.switchComp;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'type': 'Rotary',
        'poles': 2,
        'positions': 6,
      }, 10);

      final toggleSw = inventoryRepository.components.single as Switch;
      expect(toggleSw.type, 'Rotary');
      expect(toggleSw.poles, 2);
      expect(toggleSw.switching, null);
      expect(toggleSw.positions, 6);
      expect(toggleSw.momentary, false);
      expect(toggleSw.toggleSize, null);
      expect(toggleSw.bodySize, null);
      expect(toggleSw.shaftDiameter, null);
      expect(toggleSw.shaftType, null);
      expect(toggleSw.mount, null);
      expect(toggleSw.led, null);
      expect(toggleSw.quantity, 10);
    });

    test('Create rotary switch with all fields', () {
      final inventoryRepository = InMemoryInventoryRepository();
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );
      viewModel.category = ComponentCategory.switchComp;

      expect(inventoryRepository.components.isEmpty, true);

      viewModel.save(<String, dynamic>{
        'type': 'Rotary',
        'poles': 1,
        'positions': 12,
        'size_mm': '16mm',
        'shaft_type': 'Knurled',
        'shaft_diameter_mm': '6mm',
        'mount': 'Lugs',
      }, 10);

      final toggleSw = inventoryRepository.components.single as Switch;
      expect(toggleSw.type, 'Rotary');
      expect(toggleSw.poles, 1);
      expect(toggleSw.switching, null);
      expect(toggleSw.positions, 12);
      expect(toggleSw.momentary, false);
      expect(toggleSw.toggleSize, null);
      expect(toggleSw.bodySize, '16mm');
      expect(toggleSw.shaftDiameter, '6mm');
      expect(toggleSw.shaftType, 'Knurled');
      expect(toggleSw.mount, 'Lugs');
      expect(toggleSw.led, null);
      expect(toggleSw.quantity, 10);
    });

    test('Update rotary switch', () {
      final inventoryRepository = InMemoryInventoryRepository()
        ..addComponent(
          Switch(
            id: 'a',
            type: 'Rotary',
            poles: 1,
            positions: 12,
            bodySize: '16mm',
            shaftDiameter: '6mm',
            shaftType: 'Knurled',
            mount: 'Lugs',
          ),
        );
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.update('a', <String, dynamic>{
        'poles': '3',
        'positions': '4',
        'size_mm': '9mm',
        'shaft_type': null,
        'shaft_diameter_mm': null,
        'mount': 'PCB (pins)',
      }, 5);

      expect(
        inventoryRepository.components.single,
        Switch(
          id: 'a',
          type: 'Rotary',
          poles: 3,
          positions: 4,
          bodySize: '9mm',
          shaftDiameter: null,
          shaftType: null,
          mount: 'PCB (pins)',
          quantity: 5,
        ),
      );
    });

    test('Change rotary switch to footswitch', () {
      final inventoryRepository = InMemoryInventoryRepository()
        ..addComponent(
          Switch(
            id: 'a',
            type: 'Rotary',
            poles: 1,
            positions: 12,
            bodySize: '16mm',
            shaftDiameter: '6mm',
            shaftType: 'Knurled',
            mount: 'Lugs',
          ),
        );
      final viewModel = AddEditComponentViewModel(
        inventoryRepository: inventoryRepository,
      );

      viewModel.update('a', <String, dynamic>{
        'type': 'Footswitch',
        'poles': '2',
        'switching': 'On-On',
        'led': 'Blue',
      }, 5);

      expect(
        inventoryRepository.components.single,
        Switch(
          id: 'a',
          type: 'Footswitch',
          poles: 2,
          switching: 'On-On',
          positions: null,
          bodySize: null,
          shaftDiameter: null,
          shaftType: null,
          mount: null,
          led: 'Blue',
          quantity: 5,
        ),
      );
    });
  });
}
