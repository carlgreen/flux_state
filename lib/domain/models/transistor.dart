import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Transistor extends Component {
  static const partNumberKey = 'part_number';
  static const partFamilyKey = 'part_family';
  static const typeKey = 'type';
  static const packageKey = 'package';

  Transistor({
    required super.id,
    required this.partNumber,
    this.partFamily,
    this.type,
    this.package,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.transistor,
         attrs: {
           partNumberKey: partNumber,
           partFamilyKey: partFamily,
           typeKey: type,
           packageKey: package,
         },
       );

  final String partNumber;
  final String? partFamily;
  final String? type;
  final String? package;

  @override
  String display() {
    var details = partNumber;
    if (partFamily != null) {
      details = '$details ($partFamily)';
    }
    if (type != null) {
      details = '$details $type';
    }
    if (package != null) {
      details = '$details $package';
    }
    return details;
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Transistor &&
      partNumber == other.partNumber &&
      partFamily == other.partFamily &&
      type == other.type &&
      package == other.package &&
      quantity == other.quantity;

  @override
  int get hashCode =>
      Object.hash(partNumber, partFamily, type, package, quantity);

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    String partNumber = this.partNumber;
    String? partFamily = this.partFamily;
    String? type = this.type;
    String? package = this.package;
    attrs.forEach((k, v) {
      switch (k) {
        case Transistor.partNumberKey:
          partNumber = v;
        case Transistor.partFamilyKey:
          partFamily = v;
        case Transistor.typeKey:
          type = v;
        case Transistor.packageKey:
          package = v;
        default:
          debugPrint('unknown field $k');
      }
    });
    final update = Transistor(
      id: id,
      partNumber: partNumber,
      partFamily: partFamily,
      type: type,
      package: package,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Transistor(
      id: id,
      partNumber: attrs[Transistor.partNumberKey],
      partFamily: attrs[Transistor.partFamilyKey],
      type: attrs[Transistor.typeKey],
      package: attrs[Transistor.packageKey],
    );
  }
}
