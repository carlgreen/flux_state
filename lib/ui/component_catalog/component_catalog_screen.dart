import 'package:flutter/material.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

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
