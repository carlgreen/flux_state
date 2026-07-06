import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_screen.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

void main() {
  group('ComponentCatalogScreen tests', () {
    late ComponentCatalogViewModel viewModel;
    late InventoryRepository inventoryRepository;

    setUp(() {
      inventoryRepository = InventoryRepository()
        ..addResistor(Resistor(value: 1000, tolerance: 2, power: 250))
        ..addDiode(Diode(code: '1N34A'));
      viewModel = ComponentCatalogViewModel(
        inventoryRepository: inventoryRepository,
      );
    });

    Future<void> loadWidget(WidgetTester tester) async {
      await testApp(tester, ComponentCatalogScreen(viewModel: viewModel));
    }

    testWidgets('should display all components by default', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);

      expect(find.text('RESISTOR'), findsOneWidget);
      expect(find.text('1 kΩ 1/4 W (± 2%)'), findsOneWidget);

      expect(find.text('DIODE'), findsOneWidget);
      expect(find.text('1N34A'), findsOneWidget);
    });

    testWidgets('should filter to only resistors', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('RESISTORS'));
      await tester.pumpAndSettle();

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);

      expect(find.text('RESISTOR'), findsOneWidget);
      expect(find.text('1 kΩ 1/4 W (± 2%)'), findsOneWidget);

      expect(find.text('DIODE'), findsNothing);
    });

    testWidgets('should filter to only diodes', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('DIODES'));
      await tester.pumpAndSettle();

      expect(find.text('DIODE'), findsOneWidget);
      expect(find.text('1N34A'), findsOneWidget);

      expect(find.text('RESISTOR'), findsNothing);
    });

    testWidgets('should filter by search', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      final field = find.ancestor(
        of: find.text('Filter by name, value, or ...'),
        matching: find.byType(TextField),
      );

      await tester.enterText(field, '1n');
      await tester.pump();

      expect(find.text('DIODE'), findsOneWidget);
      expect(find.text('1N34A'), findsOneWidget);

      expect(find.text('RESISTOR'), findsNothing);

      await tester.enterText(field, '1 k');
      await tester.pump();

      expect(find.text('RESISTOR'), findsOneWidget);
      expect(find.text('1 kΩ 1/4 W (± 2%)'), findsOneWidget);

      expect(find.text('DIODE'), findsNothing);

      await tester.enterText(field, 'xxx');
      await tester.pump();

      expect(find.text('RESISTOR'), findsNothing);
      expect(find.text('DIODE'), findsNothing);

      final clearButton = find.ancestor(
        of: find.byIcon(Icons.clear),
        matching: find.byType(IconButton),
      );

      await tester.tap(clearButton);
      await tester.pump();

      expect(find.text('RESISTOR'), findsOneWidget);
      expect(find.text('DIODE'), findsOneWidget);
    });
  });
}

Future<void> testApp(WidgetTester tester, Widget body) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: body)));
}
