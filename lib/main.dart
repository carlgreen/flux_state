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
    final ComponentCatalogViewModel viewModel = ComponentCatalogViewModel(
      model: widget.model,
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

class InventoryModel {
  final List<Resistor> resistors = List.empty(growable: true);
  final List<Diode> diodes = List.empty(growable: true);

  InventoryModel();
}

class ComponentCatalogViewModel extends ChangeNotifier {
  ComponentCatalogViewModel({required this._model});

  final InventoryModel _model;

  Iterable<Resistor> get resistors => _model.resistors;
  Iterable<Diode> get diodes => _model.diodes;

  void _addResistor() {
    _model.resistors.add(
      Resistor(value: '10k', tolerance: '5%', power: '1/4W'),
    );
  }

  void _addDiode() {
    _model.diodes.add(Diode(code: '1N34A'));
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
      'Resistors' => _model.resistors,
      'Diodes' => _model.diodes,
      _ => List.empty(),
    };
  }
}
