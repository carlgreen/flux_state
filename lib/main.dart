import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/repository_provider.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_screen.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

void main() {
  final inventoryRepository = InventoryRepository();
  runApp(
    RepositoryProvider(
      inventoryRepository: inventoryRepository,
      child: const MainApp(),
    ),
  );
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
    final ComponentCatalogViewModel viewModel = ComponentCatalogViewModel(
      inventoryRepository: RepositoryProvider.of(context),
    );

    return ComponentCatalogScreen(viewModel: viewModel);
  }
}
