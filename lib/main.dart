import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/in_memory_inventory_repository.dart';
import 'package:flux_state/repository_provider.dart';
import 'package:flux_state/theme/app_theme.dart';
import 'package:flux_state/ui/home/home_screen.dart';
import 'package:flux_state/ui/home/home_viewmodel.dart';

void main() {
  final inventoryRepository = InMemoryInventoryRepository();
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
      theme: AppTheme.darkTheme,
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
    final HomeViewModel viewModel = HomeViewModel(
      inventoryRepository: RepositoryProvider.of(context),
    );

    return HomeScreen(viewModel: viewModel);
  }
}
