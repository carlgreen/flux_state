import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_screen.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';
import 'package:flux_state/ui/component_catalog/quantity_stepper.dart';

import '../../data/repositories/in_memory_inventory_repository.dart';

void main() {
  selectDropdown(tester, finder, value) async {
    await tester.tap(finder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final itemFinder = find.text(value).last;
    await tester.tap(itemFinder, warnIfMissed: false);
    await tester.pump();
  }

  group('AddEditComponentScreen add tests', () {
    testWidgets('should fail if resistor quantity is not a number', (
      tester,
    ) async {
      final setup = await setItUp(
        null,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      final quantityField = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byType(TextField),
      );

      final saveBtn = find.text('SAVE');

      await tester.tap(saveBtn);
      await tester.pump();

      // its ok first up because it defaults to 0
      expect(find.text('Quantity is required'), findsNothing);
      expect(find.text('Quantity must be a number'), findsNothing);

      await tester.enterText(quantityField, '');

      await tester.tap(saveBtn);
      await tester.pump();

      expect(find.text('Quantity is required'), findsOneWidget);

      await tester.enterText(quantityField, 'a');

      await tester.tap(saveBtn);
      await tester.pump();

      expect(find.text('Quantity must be a number'), findsOneWidget);

      await tester.enterText(quantityField, '1');

      await tester.tap(saveBtn);
      await tester.pump();

      expect(find.text('Quantity is required'), findsNothing);
      expect(find.text('Quantity must be a number'), findsNothing);
    });

    testWidgets('resistor should save correct data', (tester) async {
      final setup = await setItUp(
        null,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      final valueField = find.ancestor(
        of: find.text('Value'),
        matching: find.byType(TextField),
      );
      final powerField = find.ancestor(
        of: find.text('Power (W)'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final toleranceField = find.ancestor(
        of: find.text('Tolerance (%)'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final materialField = find.ancestor(
        of: find.text('Material'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final packageField = find.ancestor(
        of: find.text('Package'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final quantityField = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byType(TextField),
      );
      final incQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.add_rounded),
      );
      final decQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.remove_rounded),
      );

      final saveBtn = find.text('SAVE');

      await tester.enterText(valueField, '10k');
      await selectDropdown(tester, powerField, '0.25');
      await selectDropdown(tester, toleranceField, '2');
      await selectDropdown(tester, materialField, 'Metal Film');
      await selectDropdown(tester, packageField, '0402');

      await tester.enterText(quantityField, '5');
      await tester.tap(incQuantityBtn);
      await tester.tap(incQuantityBtn);
      await tester.tap(decQuantityBtn);

      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(await setup.inventoryRepository.components, [
        Resistor(
          id: 'a',
          value: 10000000,
          tolerance: '2',
          power: '0.25',
          material: 'Metal Film',
          package: '0402',
          quantity: 6,
        ),
      ]);
    });

    testWidgets('capacitor should save correct data', (tester) async {
      final setup = await setItUp(
        null,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      final capacitorButton = find.widgetWithText(
        AnimatedContainer,
        "CAPACITOR",
      );
      await tester.tap(capacitorButton);
      await tester.pump();

      final valueField = find.ancestor(
        of: find.text('Value'),
        matching: find.byType(TextField),
      );
      final voltageField = find.ancestor(
        of: find.text('Voltage Rating (V)'),
        matching: find.byType(TextField),
      );
      final toleranceField = find.ancestor(
        of: find.text('Tolerance (%)'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final materialField = find.ancestor(
        of: find.text('Type / Dielectric'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final polarisedField = find.descendant(
        of: find.widgetWithText(Row, 'Polarised'),
        matching: find.byType(Switch),
      );
      final incQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.add_rounded),
      );

      final saveBtn = find.text('SAVE');

      await tester.enterText(valueField, '150 pF');
      await tester.enterText(voltageField, '25');
      await selectDropdown(tester, toleranceField, '5');
      await selectDropdown(tester, materialField, 'Ceramic (MLCC)');
      await tester.tap(polarisedField);

      await tester.tap(incQuantityBtn);

      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(await setup.inventoryRepository.components, [
        Capacitor(
          id: 'b',
          value: 150,
          voltage: 25,
          tolerance: '5',
          material: 'Ceramic (MLCC)',
          polarised: true,
          quantity: 1,
        ),
      ]);
    });

    testWidgets('diode should save correct data', (tester) async {
      final setup = await setItUp(
        null,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      final diodeButton = find.widgetWithText(AnimatedContainer, "DIODE");
      await tester.tap(diodeButton);
      await tester.pump();

      final partNumberField = find.ancestor(
        of: find.text('Part Number'),
        matching: find.byType(TextField),
      );
      final materialField = find.ancestor(
        of: find.text('Material'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final packageField = find.ancestor(
        of: find.text('Package'),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      final quantityField = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byType(TextField),
      );
      final incQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.add_rounded),
      );
      final decQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.remove_rounded),
      );

      final saveBtn = find.text('SAVE');

      await tester.enterText(partNumberField, '1N34A');
      await selectDropdown(tester, materialField, 'Germanium');
      await selectDropdown(tester, packageField, 'DO-41');

      await tester.enterText(quantityField, '3');
      await tester.tap(decQuantityBtn);
      await tester.tap(decQuantityBtn);
      await tester.tap(incQuantityBtn);

      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(await setup.inventoryRepository.components, [
        Diode(
          id: 'b',
          partNumber: '1N34A',
          material: 'Germanium',
          package: 'DO-41',
          quantity: 2,
        ),
      ]);
    });
  });

  group('AddEditComponentScreen edit resistor tests', () {
    final List<Component> testData = [
      Resistor(
        id: 'a',
        value: 1000000,
        tolerance: '2',
        power: '0.25',
        material: 'Metal Film',
        package: '0402',
        quantity: 10,
      ),
      Diode(id: 'b', partNumber: '1N34A'),
    ];

    final valueFieldFinder = getTextFieldOf('Value');
    final toleranceFieldFinder = find.ancestor(
      of: find.text('Tolerance (%)'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final powerFieldFinder = find.ancestor(
      of: find.text('Power (W)'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final materialFieldFinder = find.ancestor(
      of: find.text('Material'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final packageFieldFinder = find.ancestor(
      of: find.text('Package'),
      matching: find.byType(DropdownButtonFormField<String>),
    );

    testWidgets('should display resistor values', (tester) async {
      final setup = await setItUp<Resistor>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AddEditComponentScreen), findsOneWidget);

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(find.text('EDIT_COMPONENT'), findsOneWidget);

      expect(getTextFromField(tester, valueFieldFinder), '1000');
      expect(getTextFromDropdown(tester, toleranceFieldFinder), '2');
      expect(getTextFromDropdown(tester, powerFieldFinder), '0.25');
      expect(getTextFromDropdown(tester, materialFieldFinder), 'Metal Film');
      expect(getTextFromDropdown(tester, packageFieldFinder), '0402');
      expect(getTextFromField(tester, quantityFieldFinder), '10');
    });

    testWidgets('should update resistor values', (tester) async {
      final setup = await setItUp<Resistor>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      final decQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.remove_rounded),
      );

      await tester.enterText(valueFieldFinder, '10000');
      await selectDropdown(tester, toleranceFieldFinder, '1');
      await selectDropdown(tester, powerFieldFinder, '0.5');
      await selectDropdown(tester, materialFieldFinder, 'Carbon Film');
      await selectDropdown(tester, packageFieldFinder, 'Through-hole');
      await tester.tap(decQuantityBtn);

      await tester.pump();

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(getTextFromField(tester, valueFieldFinder), '10000');
      expect(getTextFromDropdown(tester, toleranceFieldFinder), '1');
      expect(getTextFromDropdown(tester, powerFieldFinder), '0.5');
      expect(getTextFromDropdown(tester, materialFieldFinder), 'Carbon Film');
      expect(getTextFromDropdown(tester, packageFieldFinder), 'Through-hole');
      expect(getTextFromField(tester, quantityFieldFinder), '9');
    });

    testWidgets('should remove resistor values', (tester) async {
      final setup = await setItUp<Resistor>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      await selectDropdown(tester, toleranceFieldFinder, '');
      await selectDropdown(tester, powerFieldFinder, '');
      await selectDropdown(tester, materialFieldFinder, '');
      await selectDropdown(tester, packageFieldFinder, '');

      await tester.pump();

      expect(getTextFromDropdown(tester, toleranceFieldFinder), '');
      expect(getTextFromDropdown(tester, powerFieldFinder), '');
      expect(getTextFromDropdown(tester, materialFieldFinder), '');
      expect(getTextFromDropdown(tester, packageFieldFinder), '');
    });
  });

  group('AddEditComponentScreen edit capacitor tests', () {
    final List<Component> testData = [
      Resistor(id: 'a', value: 1000000, tolerance: '2', power: '0.25'),
      Capacitor(
        id: 'c',
        value: 4500,
        voltage: 100,
        tolerance: '10',
        material: 'Tantalum',
        polarised: true,
        quantity: 3,
      ),
    ];

    final valueFieldFinder = getTextFieldOf('Value');
    final voltageFieldFinder = getTextFieldOf('Voltage Rating (V)');
    final toleranceFieldFinder = find.ancestor(
      of: find.text('Tolerance (%)'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final materialFieldFinder = find.ancestor(
      of: find.text('Type / Dielectric'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final polarisedFieldFinder = find.descendant(
      of: find.widgetWithText(Row, 'Polarised'),
      matching: find.byType(Switch),
    );
    // final incQuantityBtn = find.descendant(
    //   of: find.byType(QuantityStepper),
    //   matching: find.byIcon(Icons.add_rounded),
    // );

    testWidgets('should display capacitor values', (tester) async {
      final setup = await setItUp<Capacitor>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AddEditComponentScreen), findsOneWidget);

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(find.text('EDIT_COMPONENT'), findsOneWidget);

      expect(getTextFromField(tester, valueFieldFinder), '4.5 nF');
      expect(getTextFromField(tester, voltageFieldFinder), '100');
      await selectDropdown(tester, toleranceFieldFinder, '10');
      await selectDropdown(tester, materialFieldFinder, 'Tantalum');
      expect(getValueFromSwitch(tester, polarisedFieldFinder), true);
      expect(getTextFromField(tester, quantityFieldFinder), '3');
    });

    testWidgets('should update capacitor values', (tester) async {
      final setup = await setItUp<Capacitor>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      await tester.enterText(valueFieldFinder, '4n7');
      await tester.enterText(voltageFieldFinder, '25');
      await selectDropdown(tester, toleranceFieldFinder, '20');
      await selectDropdown(tester, materialFieldFinder, 'Film (Polyester)');
      await tester.tap(polarisedFieldFinder);

      await tester.pump();

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(getTextFromField(tester, valueFieldFinder), '4n7');
      expect(getTextFromField(tester, voltageFieldFinder), '25');
      expect(getTextFromDropdown(tester, toleranceFieldFinder), '20');
      expect(
        getTextFromDropdown(tester, materialFieldFinder),
        'Film (Polyester)',
      );
      expect(getValueFromSwitch(tester, polarisedFieldFinder), false);
    });

    testWidgets('should remove capacitor values', (tester) async {
      final setup = await setItUp<Capacitor>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      await tester.enterText(voltageFieldFinder, '');
      await selectDropdown(tester, toleranceFieldFinder, '');
      await selectDropdown(tester, materialFieldFinder, '');

      await tester.pump();

      expect(getTextFromField(tester, voltageFieldFinder), '');
      expect(getTextFromDropdown(tester, toleranceFieldFinder), '');
      expect(getTextFromDropdown(tester, materialFieldFinder), '');
    });
  });

  group('AddEditComponentScreen edit diode tests', () {
    final List<Component> testData = [
      Resistor(id: 'a', value: 1000000, tolerance: '2', power: '0.25'),
      Diode(
        id: 'b',
        partNumber: '1N34A',
        material: 'Germanium',
        package: 'SOD-123',
        quantity: 3,
      ),
    ];

    final codeFieldFinder = getTextFieldOf('Part Number');
    final materialFieldFinder = find.ancestor(
      of: find.text('Material'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final packageFieldFinder = find.ancestor(
      of: find.text('Package'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    final incQuantityBtn = find.descendant(
      of: find.byType(QuantityStepper),
      matching: find.byIcon(Icons.add_rounded),
    );

    testWidgets('should display diode values', (tester) async {
      final setup = await setItUp<Diode>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AddEditComponentScreen), findsOneWidget);

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(find.text('EDIT_COMPONENT'), findsOneWidget);

      expect(getTextFromField(tester, codeFieldFinder), '1N34A');
      await selectDropdown(tester, materialFieldFinder, 'Germanium');
      await selectDropdown(tester, packageFieldFinder, 'SOD-123');
      expect(getTextFromField(tester, quantityFieldFinder), '3');
    });

    testWidgets('should update diode values', (tester) async {
      final setup = await setItUp<Diode>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      await tester.enterText(codeFieldFinder, 'new code');
      await selectDropdown(tester, materialFieldFinder, 'Silicon');
      await selectDropdown(tester, packageFieldFinder, 'DO-35');
      await tester.tap(incQuantityBtn);

      await tester.pump();

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(getTextFromField(tester, codeFieldFinder), 'new code');
      expect(getTextFromDropdown(tester, materialFieldFinder), 'Silicon');
      expect(getTextFromDropdown(tester, packageFieldFinder), 'DO-35');
      expect(getTextFromField(tester, quantityFieldFinder), '4');
    });

    testWidgets('should remove diode values', (tester) async {
      final setup = await setItUp<Diode>(
        testData,
        initialCategory: ComponentCategory.resistor,
      );
      await setup.loadWidget(tester);
      await tester.pumpAndSettle();

      await selectDropdown(tester, materialFieldFinder, '');
      await selectDropdown(tester, packageFieldFinder, '');

      await tester.pump();

      expect(getTextFromDropdown(tester, materialFieldFinder), '');
      expect(getTextFromDropdown(tester, packageFieldFinder), '');
    });
  });
}

class TestSetup {
  final InMemoryInventoryRepository inventoryRepository;
  final AddEditComponentViewModel viewModel;

  TestSetup(this.inventoryRepository, this.viewModel);

  Future<void> loadWidget(WidgetTester tester) async {
    await testApp(tester, AddEditComponentScreen(viewModel: viewModel));
  }
}

/// to create AddEditComponentViewModel view a componentId, call this
/// with a specific type, e.g. `setItUp<Diode>`. To not provide this
/// just call `setItUp`. Note that calling `setItUp<Component>`
/// will not find the first of any type rather it will be set to null.
Future<TestSetup> setItUp<C extends Component>(
  List<Component>? testData, {
  required ComponentCategory initialCategory,
}) async {
  final inventoryRepository = InMemoryInventoryRepository(testData)..loaded();

  final String? componentId;
  if (C == Component) {
    componentId = null;
  } else {
    final matches = (await inventoryRepository.components).whereType<C>();
    if (matches.isEmpty) {
      throw StateError(
        'setItUpFor: expected testData to contain a $C, but none was found.',
      );
    }
    componentId = matches.first.id;
  }
  final viewModel = AddEditComponentViewModel(
    initialCategory: initialCategory,
    inventoryRepository: inventoryRepository,
    componentId: componentId,
  );
  return TestSetup(inventoryRepository, viewModel);
}

Future<void> testApp(WidgetTester tester, Widget body) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: body)));
}

Finder getTextFieldOf(String hint) {
  final fieldFinder = find.ancestor(
    of: find.text(hint),
    matching: find.byType(TextField),
  );

  return fieldFinder;
}

String getTextFromField(WidgetTester tester, Finder finder) {
  final valueText = tester.widget<EditableText>(
    find.descendant(of: finder, matching: find.byType(EditableText)),
  );
  return valueText.controller.text;
}

String? getTextFromDropdown(WidgetTester tester, Finder finder) {
  final valueText = tester.widget<DropdownButton<String>>(
    find.descendant(of: finder, matching: find.byType(DropdownButton<String>)),
  );
  return valueText.value;
}

bool getValueFromSwitch(WidgetTester tester, Finder finder) {
  final valueText = tester.widget<Switch>(finder);
  return valueText.value;
}
