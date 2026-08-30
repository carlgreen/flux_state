import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Diode extends Component {
  static const partNumberKey = 'part_number';
  static const materialKey = 'material';
  static const packageKey = 'package';

  Diode({
    required super.id,
    required this.partNumber,
    this.material,
    this.package,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.diode,
         attrs: {
           partNumberKey: partNumber,
           materialKey: material,
           packageKey: package,
         },
       );

  final String partNumber;
  final String? material;
  final String? package;

  @override
  String display() {
    var details = '';
    if (material != null) {
      details = '$details $material';
    }
    if (package != null) {
      details = '$details $package';
    }
    if (details.isNotEmpty) {
      details = ' (${details.trim()})';
    }
    return '$partNumber$details';
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Diode &&
      partNumber == other.partNumber &&
      material == other.material &&
      package == other.package &&
      quantity == other.quantity;

  @override
  int get hashCode => Object.hash(partNumber, material, package, quantity);

  @override
  int compareTo(Component other) {
    if (other is Diode) {
      return partNumber.compareTo(other.partNumber);
    } else {
      return super.compareTo(other);
    }
  }

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    String partNumber = this.partNumber;
    String? material = this.material;
    String? package = this.package;
    attrs.forEach((k, v) {
      switch (k) {
        case Diode.partNumberKey:
          partNumber = v;
        case Diode.materialKey:
          material = v;
        case Diode.packageKey:
          package = v;
        default:
          debugPrint('unknown field $k');
      }
    });
    final update = Diode(
      id: id,
      partNumber: partNumber,
      material: material,
      package: package,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Diode(
      id: id,
      partNumber: attrs[Diode.partNumberKey],
      material: attrs[Diode.materialKey],
      package: attrs[Diode.packageKey],
    );
  }
}
