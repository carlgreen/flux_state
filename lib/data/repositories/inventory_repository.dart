import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';

class InventoryRepository {
  final List<Resistor> _resistors = List.empty(growable: true);
  final List<Diode> _diodes = List.empty(growable: true);

  InventoryRepository();

  Iterable<Resistor> get resistors => List.unmodifiable(_resistors);

  void addResistor(Resistor r) {
    _resistors.add(r);
  }

  Iterable<Diode> get diodes => List.unmodifiable(_diodes);

  void addDiode(Diode d) {
    _diodes.add(d);
  }
}
