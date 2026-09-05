import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/led.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/domain/models/transistor.dart';
import 'package:flux_state/repository_provider.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_screen.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

import '../../data/repositories/in_memory_inventory_repository.dart';

void main() {
  group('ComponentCatalogScreen tests', () {
    final List<Component> testData = [
      Resistor(
        id: 'a',
        value: 1000000,
        tolerance: '2',
        power: '1/4',
        material: 'Metal Film',
      ),
      Capacitor(
        id: 'c',
        value: 1500,
        voltage: 10,
        tolerance: '20',
        material: 'Silver Mica',
        polarised: true,
      ),
      Diode(id: 'b', partNumber: '1N34A'),
      Led(id: 'd', colour: 'Red', size: '5mm'),
      Transistor(id: 'e', partNumber: 'BC517', type: 'NPN', package: 'TO-92'),
    ];

    testWidgets('should display all components by default', (tester) async {
      final setup = setItUp(testData);
      await setup.loadWidget(tester);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      setup.inventoryRepository.loaded();
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.text('RESISTOR'), findsOneWidget);
      expect(find.text('1 kΩ 1/4 W ± 2% Metal Film'), findsOneWidget);

      expect(find.text('CAPACITOR'), findsOneWidget);
      expect(
        find.text('1.5 nF polarised 10 V ± 20% (Silver Mica)'),
        findsOneWidget,
      );

      expect(find.text('DIODE'), findsOneWidget);
      expect(find.text('1N34A'), findsOneWidget);

      expect(find.text('LEDS'), findsOneWidget);
      expect(find.text('Red 5mm'), findsOneWidget);

      expect(find.text('TRANSISTORS'), findsOneWidget);
      expect(find.text('BC517 NPN TO-92'), findsOneWidget);
    });

    testWidgets('should filter to only resistors', (tester) async {
      final setup = setItUp(testData);
      await setup.loadWidget(tester);
      setup.inventoryRepository.loaded();
      await tester.pumpAndSettle();

      await tester.tap(find.text('RESISTORS'));
      await tester.pumpAndSettle();

      expect(find.byType(ComponentCatalogScreen), findsOneWidget);

      expect(find.text('RESISTOR'), findsOneWidget);
      expect(find.text('1 kΩ 1/4 W ± 2% Metal Film'), findsOneWidget);

      expect(find.text('DIODE'), findsNothing);
    });

    testWidgets('should filter to only diodes', (tester) async {
      final setup = setItUp(testData);
      await setup.loadWidget(tester);
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      setup.inventoryRepository.loaded();

      await tester.tap(find.text('DIODES'));
      await tester.pumpAndSettle();

      expect(find.text('DIODE'), findsOneWidget);
      expect(find.text('1N34A'), findsOneWidget);

      expect(find.text('RESISTOR'), findsNothing);
    });

    testWidgets('should filter by search', (tester) async {
      final setup = setItUp(testData);
      await setup.loadWidget(tester);
      setup.inventoryRepository.loaded();
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
      expect(find.text('1 kΩ 1/4 W ± 2% Metal Film'), findsOneWidget);

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

    testWidgets('Navigate to edit component screen', (tester) async {
      final setup = setItUp(testData);
      await setup.loadWidget(tester);
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      setup.inventoryRepository.loaded();
      await tester.pumpAndSettle();

      await tester.tap(find.text('1N34A'));
      await tester.pumpAndSettle();

      expect(find.text('EDIT_COMPONENT'), findsOneWidget);
      expect(find.text('1N34A'), findsOneWidget);
    });
  });

  group('ComponentCatalogScreen with initial category', () {
    final List<Component> testData = [
      Resistor(id: 'a', value: 1000, tolerance: '2', power: '0.25'),
      Diode(id: 'b', partNumber: '1N34A'),
    ];

    testWidgets('should start on the initial category', (tester) async {
      final setup = setItUp(testData, ComponentCategory.diode);
      await setup.loadWidget(tester);
      await tester.pump(const Duration(milliseconds: 10));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      setup.inventoryRepository.loaded();
      await tester.pumpAndSettle();

      expect(find.text('DIODE'), findsOneWidget);
      expect(find.text('1N34A'), findsOneWidget);

      expect(find.text('RESISTOR'), findsNothing);
    });
  });
}

class TestSetup {
  final InMemoryInventoryRepository inventoryRepository;
  final ComponentCatalogViewModel viewModel;

  TestSetup(this.inventoryRepository, this.viewModel);

  Future<void> loadWidget(WidgetTester tester) async {
    await testApp(
      tester,
      ComponentCatalogScreen(viewModel: viewModel),
      inventoryRepository,
    );
  }
}

TestSetup setItUp(
  List<Component>? testData, [
  ComponentCategory? initialCategory,
]) {
  final inventoryRepository = InMemoryInventoryRepository(testData);
  final viewModel = ComponentCatalogViewModel(
    inventoryRepository: inventoryRepository,
    initialCategory: initialCategory,
  );

  return TestSetup(inventoryRepository, viewModel);
}

Future<void> testApp(
  WidgetTester tester,
  Widget body,
  InventoryRepository mockRepository,
) async {
  tester.view.devicePixelRatio = 1.0;
  await tester.binding.setSurfaceSize(const Size(1200, 800));
  await tester.pumpWidget(
    RepositoryProvider(
      inventoryRepository: mockRepository,
      child: MaterialApp(home: Scaffold(body: body)),
    ),
  );
}
