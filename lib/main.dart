import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
        body: const Center(child: FluxStateApp()),
      ),
    );
  }
}

class FluxStateApp extends StatelessWidget {
  const FluxStateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComponentCatalogScreen();
  }
}

class ComponentCatalogScreen extends StatefulWidget {
  const ComponentCatalogScreen({super.key});

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
              componentType: items[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentCatalogDetailScreen extends StatelessWidget {
  const _ComponentCatalogDetailScreen({required this.componentType});

  final String componentType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(componentType, style: Theme.of(context).textTheme.headlineSmall),
        const Text('things'),
      ],
    );
  }
}
