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
  group('AddEditComponentScreen tests', () {
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
        Resistor(value: 10, tolerance: 2, power: 250, quantity: 6),
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

      expect(inventoryRepository.diodes, [Diode(code: '1N34A', quantity: 2)]);
    });
  });
}

Future<void> testApp(WidgetTester tester, Widget body) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: body)));
}
