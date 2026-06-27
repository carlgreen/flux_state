import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_screen.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';

void main() {
  group('AddEditComponentScreen tests', () {
    late AddEditComponentViewModel viewModel;
    late InventoryRepository inventoryRepository;

    setUp(() {
      inventoryRepository = InventoryRepository();
      viewModel = AddEditComponentViewModel(
        componentType: 'Resistors',
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

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('$fieldName is required'), findsOneWidget);

      await tester.enterText(field, 'a');

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('$fieldName must be a number'), findsOneWidget);

      await tester.enterText(field, '1');

      await tester.tap(find.text('Save'));
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

      final quantityField = find.ancestor(
        of: find.text('Quantity'),
        matching: find.byType(TextField),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      // its ok first up because it defaults to 0
      expect(find.text('Quantity is required'), findsNothing);
      expect(find.text('Quantity must be a number'), findsNothing);

      await tester.enterText(quantityField, '');

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Quantity is required'), findsOneWidget);

      await tester.enterText(quantityField, 'a');

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Quantity must be a number'), findsOneWidget);

      await tester.enterText(quantityField, '1');

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Quantity is required'), findsNothing);
      expect(find.text('Quantity must be a number'), findsNothing);
    });
  });
}

Future<void> testApp(WidgetTester tester, Widget body) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: body)));
}
