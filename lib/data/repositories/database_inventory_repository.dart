import 'package:flux_state/data/repositories/database_helper.dart';
import 'package:flux_state/data/repositories/inventory_repository.dart';
import 'package:flux_state/domain/models/capacitor.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/ic.dart';
import 'package:flux_state/domain/models/led.dart';
import 'package:flux_state/domain/models/potentiometer.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/domain/models/switch.dart';
import 'package:flux_state/domain/models/transistor.dart';

const String _tableComponents = 'components';

class DatabaseInventoryRepository implements InventoryRepository {
  DatabaseInventoryRepository();

  @override
  Future<Iterable<Component>> get components async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      _tableComponents,
      // orderBy: 'category ASC, name ASC',
      orderBy: 'category ASC',
    );
    return rows.map(Component.fromMap);
  }

  Future<int> addComponent(Component c) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert(_tableComponents, c.toMap());
  }

  Future<int> saveComponent(Component update) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      _tableComponents,
      update.toMap(),
      where: 'id = ?',
      whereArgs: [update.id],
    );
  }

  @override
  Future<int> add(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int quantity,
  ) {
    final Component c;
    switch (category) {
      case ComponentCategory.resistor:
        c = Resistor.fromAttrs(id, attrs);
      case ComponentCategory.capacitor:
        c = Capacitor.fromAttrs(id, attrs);
      case ComponentCategory.diode:
        c = Diode.fromAttrs(id, attrs);
      case ComponentCategory.led:
        c = Led.fromAttrs(id, attrs);
      case ComponentCategory.transistor:
        c = Transistor.fromAttrs(id, attrs);
      case ComponentCategory.ic:
        c = Ic.fromAttrs(id, attrs);
      case ComponentCategory.potentiometer:
        c = Potentiometer.fromAttrs(id, attrs);
      case ComponentCategory.switchComp:
        c = Switch.fromAttrs(id, attrs);
    }
    c.quantity = quantity;
    return addComponent(c);
  }

  @override
  Future<int> save(
    ComponentCategory category,
    String id,
    Map<String, dynamic> attrs,
    int qty,
  ) async {
    final component = await load(id);
    if (component != null) {
      final update = component.updateFromAttrs(attrs);
      update.quantity = qty;
      return saveComponent(update);
    }

    return Future.error('no component for $id');
  }

  @override
  Future<Component?> load(String id) async {
    return (await components).where((c) => c.id == id).singleOrNull;
  }
}
