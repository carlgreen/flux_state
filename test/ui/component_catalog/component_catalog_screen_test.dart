import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_screen.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

void main() {
  group('ComponentCatalogScreen tests', () {
    late ComponentCatalogViewModel viewModel;
    late InventoryRepository inventoryRepository;

    setUp(() {
      inventoryRepository = InventoryRepository();
      // ..addResistor(Resistor(value: '1k', tolerance: '2%', power: '1/3W'));
      viewModel = ComponentCatalogViewModel(
        inventoryRepository: inventoryRepository,
      );
    });

    Future<void> loadWidget(WidgetTester tester) async {
      await testApp(tester, ComponentCatalogScreen(viewModel: viewModel));
    }

    testWidgets('should load screen on resistors by default', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);

      expect(find.text('Resistors'), findsNWidgets(2));
    });

    testWidgets('should navigate to diodes', (tester) async {
      await loadWidget(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Diodes'));
      await tester.pumpAndSettle();

      expect(find.text('Diodes'), findsNWidgets(2));
    });

    testWidgets('should increment resistor count', (tester) async {
      inventoryRepository.addResistor(
        Resistor(value: '1k', tolerance: '5%', power: '1/4W'),
      );
      inventoryRepository.addResistor(
        Resistor(value: '10k', tolerance: '5%', power: '1/4W'),
      );

      await loadWidget(tester);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.add).last);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });
  });
}

Future<void> testApp(WidgetTester tester, Widget body) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: body)));
}
