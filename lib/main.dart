import 'package:flutter/material.dart';

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

class ComponentCatalogScreen extends StatefulWidget {
  const ComponentCatalogScreen({super.key, required this.viewModel});

  final ComponentCatalogViewModel viewModel;

  @override
  State<ComponentCatalogScreen> createState() => _ComponentCatalogScreenState();
}

class _ComponentCatalogScreenState extends State<ComponentCatalogScreen> {
  final items = ['Resistors', 'Diodes'];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final item in items)
                NavigationRailDestination(
                  icon: const Icon(Icons.electrical_services_outlined),
                  label: Text(item),
                ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _ComponentCatalogDetailScreen(
              viewModel: widget.viewModel,
              componentType: items[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentCatalogDetailScreen extends StatefulWidget {
  const _ComponentCatalogDetailScreen({
    required this.viewModel,
    required this.componentType,
  });

  final ComponentCatalogViewModel viewModel;
  final String componentType;

  @override
  State<_ComponentCatalogDetailScreen> createState() =>
      _ComponentCatalogDetailScreenState();
}

class _ComponentCatalogDetailScreenState
    extends State<_ComponentCatalogDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Iterable<dynamic> model = widget.viewModel.components(
      widget.componentType,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.componentType,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        for (final item in model)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('thing: $item'),
              ),
              IconButton(
                onPressed: () => setState(() {
                  item.add();
                }),
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () => setState(() {
                  item.remove();
                }),
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        IconButton(
          onPressed: () => setState(() {
            widget.viewModel.add(widget.componentType);
          }),
          icon: const Icon(Icons.create_new_folder),
        ),
      ],
    );
  }
}

class Resistor {
  Resistor({required this.value, required this.tolerance, required this.power});

  final String value;
  final String tolerance;
  final String power;
  int count = 0;

  void add() {
    count++;
  }

  void remove() {
    count--;

    if (count < 0) {
      count = 0;
    }
  }

  @override
  String toString() {
    return '$value $power ($tolerance): $count';
  }
}

class Diode {
  Diode({required this.code});

  final String code;
  int count = 0;

  void add() {
    count++;
  }

  void remove() {
    count--;

    if (count < 0) {
      count = 0;
    }
  }

  @override
  String toString() {
    return '$code: $count';
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

class ComponentCatalogViewModel extends ChangeNotifier {
  ComponentCatalogViewModel({required this._inventoryRepository});

  final InventoryRepository _inventoryRepository;

  Iterable<Resistor> get resistors => _inventoryRepository.resistors;
  Iterable<Diode> get diodes => _inventoryRepository.diodes;

  void _addResistor() {
    _inventoryRepository.addResistor(
      Resistor(value: '10k', tolerance: '5%', power: '1/4W'),
    );
  }

  void _addDiode() {
    _inventoryRepository.addDiode(Diode(code: '1N34A'));
  }

  void add(String componentType) {
    switch (componentType) {
      case 'Resistors':
        _addResistor();
      case 'Diodes':
        _addDiode();
      default:
        debugPrint('unexpected component type "$componentType"');
    }

    notifyListeners();
  }

  Iterable<dynamic> components(String componentType) {
    return switch (componentType) {
      'Resistors' => _inventoryRepository.resistors,
      'Diodes' => _inventoryRepository.diodes,
      _ => List.empty(),
    };
  }
}
