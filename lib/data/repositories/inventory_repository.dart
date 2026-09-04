import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';

abstract class InventoryRepository {
  Iterable<Component> get components;

  Component? load(String id);

  void add(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int quantity,
  );

  void save(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int qty,
  );
}
