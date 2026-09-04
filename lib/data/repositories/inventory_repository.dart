import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';

abstract class InventoryRepository {
  Future<Iterable<Component>> get components;

  Future<Component?> load(String id);

  Future<int> add(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int quantity,
  );

  Future<int> save(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int qty,
  );
}
