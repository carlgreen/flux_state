import 'package:flutter/material.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';

class RepositoryProvider extends InheritedWidget {
  final InventoryRepository inventoryRepository;

  const RepositoryProvider({
    super.key,
    required this.inventoryRepository,
    required super.child,
  });

  static InventoryRepository of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<RepositoryProvider>();
    if (provider == null) {
      throw FlutterError('No RepositoryProvider found in context');
    }
    return provider.inventoryRepository;
  }

  @override
  bool updateShouldNotify(RepositoryProvider oldWidget) => false; // Repositories rarely change
}
