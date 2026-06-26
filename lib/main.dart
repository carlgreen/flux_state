import 'package:flutter/material.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_screen.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

void main() {
  final inventoryRepository = InventoryRepository();
  runApp(MainApp(inventoryRepository));
}

class MainApp extends StatelessWidget {
  const MainApp(this.inventoryRepository, {super.key});

  final InventoryRepository inventoryRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('flux_state'),
          ),
        ),
        body: Center(child: FluxStateApp(inventoryRepository)),
      ),
    );
  }
}

class FluxStateApp extends StatefulWidget {
  const FluxStateApp(this.inventoryRepository, {super.key});

  final InventoryRepository inventoryRepository;

  @override
  State<FluxStateApp> createState() => _FluxStateAppState();
}

class _FluxStateAppState extends State<FluxStateApp> {
  @override
  Widget build(BuildContext context) {
    final ComponentCatalogViewModel viewModel = ComponentCatalogViewModel(
      inventoryRepository: widget.inventoryRepository,
    );

    return ComponentCatalogScreen(viewModel: viewModel);
  }
}

class InventoryRepository {
  final List<Resistor> _resistors = List.empty(growable: true);
  final List<Diode> _diodes = List.empty(growable: true);

  InventoryRepository();

  Iterable<Resistor> get resistors => List.unmodifiable(_resistors);

  void addResistor(Resistor r) {
    _resistors.add(r);
  }

  Iterable<Diode> get diodes => List.unmodifiable(_diodes);

  void addDiode(Diode d) {
    _diodes.add(d);
  }
}
