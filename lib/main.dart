import 'package:flutter/material.dart';

void main() {
  final model = InventoryModel();
  runApp(MainApp(model));
}

class MainApp extends StatelessWidget {
  const MainApp(this.model, {super.key});

  final InventoryModel model;

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
        body: Center(child: FluxStateApp(model)),
      ),
    );
  }
}

class FluxStateApp extends StatefulWidget {
  const FluxStateApp(this.model, {super.key});

  final InventoryModel model;

  @override
  State<FluxStateApp> createState() => _FluxStateAppState();
}

class _FluxStateAppState extends State<FluxStateApp> {
  @override
  Widget build(BuildContext context) {
    final InventoryViewModel viewModel = InventoryViewModel(widget.model);

    return ComponentCatalogScreen(viewModel: viewModel);
  }
}

class ComponentCatalogScreen extends StatefulWidget {
  const ComponentCatalogScreen({required this.viewModel, super.key});

  final InventoryViewModel viewModel;

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
              model: switch (_selectedIndex) {
                0 => widget.viewModel.resistors,
                1 => widget.viewModel.diodes,
                _ => null,
              },
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
    required this.model,
  });

  final InventoryViewModel viewModel;
  final String componentType;
  final Iterable? model;

  @override
  State<_ComponentCatalogDetailScreen> createState() =>
      _ComponentCatalogDetailScreenState();
}

class _ComponentCatalogDetailScreenState
    extends State<_ComponentCatalogDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.componentType,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        if (widget.model != null)
          for (final item in widget.model!)
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

class InventoryModel {
  final List<Resistor> resistors = List.empty(growable: true);
  final List<Diode> diodes = List.empty(growable: true);

  InventoryModel();
}

class InventoryViewModel extends ChangeNotifier {
  final InventoryModel model;

  InventoryViewModel(this.model);

  Iterable<Resistor> get resistors => model.resistors;
  Iterable<Diode> get diodes => model.diodes;

  void _addResistor() {
    model.resistors.add(Resistor(value: '10k', tolerance: '5%', power: '1/4W'));
  }

  void _addDiode() {
    model.diodes.add(Diode(code: '1N34A'));
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
}
