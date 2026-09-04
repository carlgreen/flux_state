import 'dart:convert';

import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Led extends Component {
  static const colourKey = 'colour';
  static const sizeKey = 'size_mm';
  static const forwardVoltageKey = 'forward_v';
  static const currentKey = 'current_ma';
  static const lensKey = 'lens';

  Led({
    required super.id,
    required this.colour,
    required this.size,
    this.forwardVoltage,
    this.current,
    this.lens,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.led,
         attrs: {
           colourKey: colour,
           sizeKey: size,
           forwardVoltageKey: forwardVoltage ?? '',
           currentKey: current ?? '',
           lensKey: lens,
         },
       );

  final String colour;
  final String size;
  final int? forwardVoltage;
  final int? current;
  final String? lens;

  @override
  String display() {
    var details = '';
    if (forwardVoltage != null) {
      details = '$details $forwardVoltage';
    }
    if (current != null) {
      details = '$details $current';
    }
    if (lens != null) {
      details = '$details $lens';
    }
    if (details.isNotEmpty) {
      details = ' (${details.trim()})';
    }
    return '$colour $size$details';
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Led &&
      colour == other.colour &&
      size == other.size &&
      forwardVoltage == other.forwardVoltage &&
      current == other.current &&
      lens == other.lens &&
      quantity == other.quantity;

  @override
  int get hashCode =>
      Object.hash(colour, size, forwardVoltage, current, lens, quantity);

  @override
  int compareTo(Component other) {
    if (other is Led) {
      var cmp = size.compareTo(other.size);
      if (cmp != 0) {
        return cmp;
      }

      return colour.compareTo(other.colour);
    } else {
      return super.compareTo(other);
    }
  }

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    String colour = this.colour;
    String size = this.size;
    int? forwardVoltage = this.forwardVoltage;
    int? current = this.current;
    String? lens = this.lens;
    attrs.forEach((k, v) {
      switch (k) {
        case Led.colourKey:
          colour = v;
        case Led.sizeKey:
          size = v;
        case Led.forwardVoltageKey:
          forwardVoltage = v != '' ? int.parse(v) : null;
        case Led.currentKey:
          current = v != '' ? int.parse(v) : null;
        case Led.lensKey:
          lens = v;
        default:
          debugPrint('unknown field $k');
      }
    });
    final update = Led(
      id: id,
      colour: colour,
      size: size,
      forwardVoltage: forwardVoltage,
      current: current,
      lens: lens,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Led(
      id: id,
      colour: attrs[Led.colourKey],
      size: attrs[Led.sizeKey],
      forwardVoltage: attrs[Led.forwardVoltageKey] != null
          ? int.parse(attrs[Led.forwardVoltageKey])
          : null,
      current: attrs[Led.currentKey] != null
          ? int.parse(attrs[Led.currentKey])
          : null,
      lens: attrs[Led.lensKey],
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'category': category.name,
      'quantity': quantity,
      'attrs': json.encode({
        colourKey: colour,
        sizeKey: size,
        forwardVoltageKey: forwardVoltage,
        currentKey: current,
        lensKey: lens,
      }),
    };
  }
}
