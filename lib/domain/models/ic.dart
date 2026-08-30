import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Ic extends Component {
  static const partNumberKey = 'part_number';
  static const partFamilyKey = 'part_family';
  static const functionKey = 'function';
  static const packageKey = 'package';

  Ic({
    required super.id,
    required this.partNumber,
    this.partFamily,
    this.function,
    this.package,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.ic,
         attrs: {
           partNumberKey: partNumber,
           partFamilyKey: partFamily,
           functionKey: function,
           packageKey: package,
         },
       );

  final String partNumber;
  final String? partFamily;
  final String? function;
  final String? package;

  @override
  String display() {
    var details = partNumber;
    if (partFamily != null) {
      details = '$details ($partFamily)';
    }
    if (function != null) {
      details = '$details $function';
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
      other is Ic &&
      partNumber == other.partNumber &&
      partFamily == other.partFamily &&
      function == other.function &&
      package == other.package &&
      quantity == other.quantity;

  @override
  int get hashCode =>
      Object.hash(partNumber, partFamily, function, package, quantity);

  @override
  int compareTo(Component other) {
    if (other is Ic) {
      return partNumber.compareTo(other.partNumber);
    } else {
      return super.compareTo(other);
    }
  }

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    String partNumber = this.partNumber;
    String? partFamily = this.partFamily;
    String? function = this.function;
    String? package = this.package;
    attrs.forEach((k, v) {
      switch (k) {
        case Ic.partNumberKey:
          partNumber = v;
        case Ic.partFamilyKey:
          partFamily = v;
        case Ic.functionKey:
          function = v;
        case Ic.packageKey:
          package = v;
        default:
          debugPrint('unknown field $k');
      }
    });
    final update = Ic(
      id: id,
      partNumber: partNumber,
      partFamily: partFamily,
      function: function,
      package: package,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Ic(
      id: id,
      partNumber: attrs[Ic.partNumberKey],
      partFamily: attrs[Ic.partFamilyKey],
      function: attrs[Ic.functionKey],
      package: attrs[Ic.packageKey],
    );
  }
}
