import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_screen.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';
import 'package:flux_state/ui/component_catalog/quantity_stepper.dart';

void main() {
  group('AddEditComponentScreen add tests', () {
    late AddEditComponentViewModel viewModel;
    late InventoryRepository inventoryRepository;

    setUp(() {
      inventoryRepository = InventoryRepository();
      viewModel = AddEditComponentViewModel(
        initialCategory: ComponentCategory.resistor,
        inventoryRepository: inventoryRepository,
      );
    });

    Future<void> loadWidget(WidgetTester tester) async {
      await testApp(tester, AddEditComponentScreen(viewModel: viewModel));
    }

    testForField(tester, String fieldName) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      final field = find.ancestor(
        of: find.text(fieldName),
        matching: find.byType(TextField),
      );

      final saveBtn = find.text('SAVE');

      await tester.tap(saveBtn);
      await tester.pump();

      expect(find.text('$fieldName is required'), findsOneWidget);

      await tester.enterText(field, 'a');

      await tester.tap(saveBtn);
      await tester.pump();

      expect(find.text('$fieldName must be a number'), findsOneWidget);

      await tester.enterText(field, '1');

      await tester.tap(saveBtn);
      await tester.pump();

      expect(find.text('$fieldName must be a number'), findsNothing);
    }

    testWidgets('should fail if resistor value is not a number', (
      tester,
    ) async {
      await testForField(tester, 'Value');
    });

    testWidgets('should fail if resistor power is not a number', (
      tester,
    ) async {
      await testForField(tester, 'Power');
    });

    testWidgets('should fail if resistor tolerance is not a number', (
      tester,
    ) async {
      await testForField(tester, 'Tolerance');
    });

    testWidgets('should fail if resistor quantity is not a number', (
      tester,
    ) async {
      await loadWidget(tester);
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
      await loadWidget(tester);
      await tester.pumpAndSettle();

      final valueField = find.ancestor(
        of: find.text('Value'),
        matching: find.byType(TextField),
      );
      final powerField = find.ancestor(
        of: find.text('Power'),
        matching: find.byType(TextField),
      );
      final toleranceField = find.ancestor(
        of: find.text('Tolerance'),
        matching: find.byType(TextField),
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

      await tester.enterText(valueField, '10');
      await tester.enterText(powerField, '250');
      await tester.enterText(toleranceField, '2');

      await tester.enterText(quantityField, '5');
      await tester.tap(incQuantityBtn);
      await tester.tap(incQuantityBtn);
      await tester.tap(decQuantityBtn);

      await tester.tap(saveBtn);
      await tester.pump();

      expect(inventoryRepository.resistors, [
        Resistor(id: 'a', value: 10, tolerance: 2, power: 250, quantity: 6),
      ]);
    });

    testWidgets('diode should save correct data', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      final diodeButton = find.widgetWithText(AnimatedContainer, "DIODE");
      await tester.tap(diodeButton);
      await tester.pump();

      final codeField = find.ancestor(
        of: find.text('Code'),
        matching: find.byType(TextField),
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

      await tester.enterText(codeField, '1N34A');

      await tester.enterText(quantityField, '3');
      await tester.tap(decQuantityBtn);
      await tester.tap(decQuantityBtn);
      await tester.tap(incQuantityBtn);

      await tester.tap(saveBtn);
      await tester.pump();

      expect(inventoryRepository.diodes, [
        Diode(id: 'b', code: '1N34A', quantity: 2),
      ]);
    });
  });

  group('AddEditComponentScreen edit resistor tests', () {
    late AddEditComponentViewModel viewModel;
    late InventoryRepository inventoryRepository;

    setUp(() {
      inventoryRepository = InventoryRepository()
        ..addResistor(
          Resistor(
            id: 'a',
            value: 1000,
            tolerance: 2,
            power: 250,
            quantity: 10,
          ),
        )
        ..addDiode(Diode(id: 'b', code: '1N34A'));
      final resistorId = inventoryRepository.resistors.first.id;
      viewModel = AddEditComponentViewModel(
        initialCategory: ComponentCategory.resistor,
        inventoryRepository: inventoryRepository,
        componentId: resistorId,
      );
    });

    Future<void> loadWidget(WidgetTester tester) async {
      await testApp(tester, AddEditComponentScreen(viewModel: viewModel));
    }

    Finder getTextFieldOf(String hint) {
      final fieldFinder = find.ancestor(
        of: find.text(hint),
        matching: find.byType(TextField),
      );
      expect(fieldFinder, findsOneWidget);

      return fieldFinder;
    }

    String getTextFromField(tester, finder) {
      final valueText = tester.widget<EditableText>(
        find.descendant(of: finder, matching: find.byType(EditableText)),
      );
      return valueText.controller.text;
    }

    testWidgets('should display resistor values', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AddEditComponentScreen), findsOneWidget);

      final valueFieldFinder = getTextFieldOf('Value');
      final toleranceFieldFinder = getTextFieldOf('Tolerance');
      final powerFieldFinder = getTextFieldOf('Power');

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(find.text('EDIT_COMPONENT'), findsOneWidget);

      expect(getTextFromField(tester, valueFieldFinder), '1000');
      expect(getTextFromField(tester, toleranceFieldFinder), '2');
      expect(getTextFromField(tester, powerFieldFinder), '250');
      expect(getTextFromField(tester, quantityFieldFinder), '10');
    });

    testWidgets('should update resistor values', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      final valueFieldFinder = getTextFieldOf('Value');
      final toleranceFieldFinder = getTextFieldOf('Tolerance');
      final powerFieldFinder = getTextFieldOf('Power');
      final decQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.remove_rounded),
      );

      await tester.enterText(valueFieldFinder, '10000');
      await tester.enterText(toleranceFieldFinder, '1');
      await tester.enterText(powerFieldFinder, '500');
      await tester.tap(decQuantityBtn);

      await tester.pump();

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(getTextFromField(tester, valueFieldFinder), '10000');
      expect(getTextFromField(tester, toleranceFieldFinder), '1');
      expect(getTextFromField(tester, powerFieldFinder), '500');
      expect(getTextFromField(tester, quantityFieldFinder), '9');
    });
  });

  group('AddEditComponentScreen edit diode tests', () {
    late AddEditComponentViewModel viewModel;
    late InventoryRepository inventoryRepository;

    setUp(() {
      inventoryRepository = InventoryRepository()
        ..addResistor(Resistor(id: 'a', value: 1000, tolerance: 2, power: 250))
        ..addDiode(Diode(id: 'b', code: '1N34A', quantity: 3));
      final diodeId = inventoryRepository.diodes.first.id;
      viewModel = AddEditComponentViewModel(
        initialCategory: ComponentCategory.resistor,
        inventoryRepository: inventoryRepository,
        componentId: diodeId,
      );
    });

    Future<void> loadWidget(WidgetTester tester) async {
      await testApp(tester, AddEditComponentScreen(viewModel: viewModel));
    }

    Finder getTextFieldOf(String hint) {
      final fieldFinder = find.ancestor(
        of: find.text(hint),
        matching: find.byType(TextField),
      );
      expect(fieldFinder, findsOneWidget);

      return fieldFinder;
    }

    String getTextFromField(tester, finder) {
      final valueText = tester.widget<EditableText>(
        find.descendant(of: finder, matching: find.byType(EditableText)),
      );
      return valueText.controller.text;
    }

    testWidgets('should display diode values', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AddEditComponentScreen), findsOneWidget);

      final codeFieldFinder = getTextFieldOf('Code');

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(find.text('EDIT_COMPONENT'), findsOneWidget);

      expect(getTextFromField(tester, codeFieldFinder), '1N34A');
      expect(getTextFromField(tester, quantityFieldFinder), '3');
    });

    testWidgets('should update diode values', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      final codeFieldFinder = getTextFieldOf('Code');
      final incQuantityBtn = find.descendant(
        of: find.byType(QuantityStepper),
        matching: find.byIcon(Icons.add_rounded),
      );

      await tester.enterText(codeFieldFinder, 'new code');
      await tester.tap(incQuantityBtn);

      await tester.pump();

      final quantityFieldFinder = find.byType(QuantityStepper);
      expect(quantityFieldFinder, findsOneWidget);

      expect(getTextFromField(tester, codeFieldFinder), 'new code');
      expect(getTextFromField(tester, quantityFieldFinder), '4');
    });
  });
}

Future<void> testApp(WidgetTester tester, Widget body) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: body)));
}
