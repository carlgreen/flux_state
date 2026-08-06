import 'component.dart';
import 'component_category.dart';

class Diode extends Component {
  static const codeKey = 'code';

  Diode({required super.id, required this.code, super.quantity = 0})
    : super(category: ComponentCategory.diode, attrs: {codeKey: code});

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
