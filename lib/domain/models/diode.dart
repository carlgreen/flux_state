import 'component.dart';
import 'component_category.dart';

class Diode extends Component {
  Diode({required this.code, super.quantity = 0})
    : super(category: ComponentCategory.diode);

  final String code;

  @override
  String display() {
    return code;
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Diode && code == other.code && quantity == other.quantity;

  @override
  int get hashCode => Object.hash(code, quantity);
}
