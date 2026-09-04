import 'dart:convert';

import 'package:flutter/material.dart';

import 'component.dart';
import 'component_category.dart';

class Switch extends Component {
  static const typeKey = 'type';
  static const polesKey = 'poles';
  static const switchingKey = 'switching';
  static const positionsKey = 'positions';
  static const momentaryKey = 'momentary';
  static const sizeKey = 'toggle_size';
  static const bodySizeKey = 'size_mm';
  static const shaftDiameterKey = 'shaft_diameter_mm';
  static const shaftTypeKey = 'shaft_type';
  static const mountKey = 'mount';
  static const ledKey = 'led';

  Switch({
    required super.id,
    required this.type,
    required this.poles,
    this.switching,
    this.positions,
    this.momentary = false,
    this.toggleSize,
    this.bodySize,
    this.shaftDiameter,
    this.shaftType,
    this.mount,
    this.led,
    super.quantity = 0,
  }) : super(
         category: ComponentCategory.switchComp,
         attrs: {
           typeKey: type,
           polesKey: poles.toString(),
           switchingKey: switching,
           positionsKey: positions?.toString(),
           momentaryKey: momentary,
           sizeKey: toggleSize,
           bodySizeKey: bodySize,
           shaftDiameterKey: shaftDiameter,
           shaftTypeKey: shaftType,
           mountKey: mount,
           ledKey: led,
         },
       );

  final String type;
  final int poles;
  final String? switching;
  final int? positions;
  final bool momentary;
  final String? toggleSize;
  final String? bodySize;
  final String? shaftDiameter;
  final String? shaftType;
  final String? mount;
  final String? led;

  @override
  String display() {
    var momentaryDetail = '';
    if (momentary) {
      momentaryDetail = ' momentary';
    }
    var details = '';
    switch (type) {
      case 'Toggle':
        var sizing = '';
        if (toggleSize != null && toggleSize != 'Normal') {
          sizing = ' $toggleSize';
        }
        details = '${poles}P $switching$momentaryDetail$sizing toggle';
        break;
      case 'Footswitch':
        var ledDetails = '';
        if (led != null) {
          ledDetails = ' ($led LED)';
        }
        details = '${poles}P $switching$momentaryDetail stomp$ledDetails';
        break;
      case 'DIP':
        var poling = '';
        if (poles != 2) {
          poling = '${poles}P ';
        }
        details = '${poling}Dip Switch $positions Positions';
        break;
      case 'Rotary':
        var shaftDetails = '';
        if (shaftDiameter != null) {
          shaftDetails = '$shaftDetails $shaftDiameter';
        }
        if (shaftType != null) {
          shaftDetails = '$shaftDetails $shaftType';
        }
        if (shaftDetails.isNotEmpty) {
          shaftDetails = '${shaftDetails.trim()} shaft';
        }
        var rotaryDetails = '';
        if (bodySize != null) {
          rotaryDetails = '$rotaryDetails $bodySize base';
        }
        if (shaftDetails.isNotEmpty) {
          rotaryDetails = '$rotaryDetails $shaftDetails';
        }
        if (mount != null) {
          rotaryDetails = '$rotaryDetails $mount';
        }
        if (rotaryDetails.isNotEmpty) {
          rotaryDetails = ' (${rotaryDetails.trim()})';
        }
        details = '${poles}P${positions}T Rotary Switch$rotaryDetails';
        break;
      default:
        details =
            '$type switch poles: $poles, switching: $switching, positions: $positions';
    }
    return details;
  }

  @override
  String toString() {
    return '${display()}: $quantity';
  }

  @override
  bool operator ==(Object other) =>
      other is Switch &&
      type == other.type &&
      poles == other.poles &&
      switching == other.switching &&
      positions == other.positions &&
      momentary == other.momentary &&
      toggleSize == other.toggleSize &&
      bodySize == other.bodySize &&
      shaftDiameter == other.shaftDiameter &&
      shaftType == other.shaftType &&
      mount == other.mount &&
      led == other.led &&
      quantity == other.quantity;

  @override
  int get hashCode => Object.hash(
    type,
    poles,
    switching,
    positions,
    momentary,
    toggleSize,
    bodySize,
    shaftDiameter,
    shaftType,
    mount,
    led,
    quantity,
  );

  @override
  int compareTo(Component other) {
    if (other is Switch) {
      var cmp = type.compareTo(other.type);
      if (cmp != 0) {
        return cmp;
      }

      cmp = poles.compareTo(other.poles);
      if (cmp != 0) {
        return cmp;
      }

      cmp = (positions ?? 0).compareTo(other.positions ?? 0);
      if (cmp != 0) {
        return cmp;
      }

      // sort On-On before On-Off-On?
      cmp = (switching ?? '')
          .split('-')
          .length
          .compareTo((other.switching ?? '').split('-').length);
      if (cmp != 0) {
        return cmp;
      }

      return 0;
    } else {
      return super.compareTo(other);
    }
  }

  @override
  Component updateFromAttrs(Map<String, dynamic> attrs) {
    String type = this.type;
    int poles = this.poles;
    String? switching = this.switching;
    int? positions = this.positions;
    bool momentary = this.momentary;
    String? toggleSize = this.toggleSize;
    String? bodySize = this.bodySize;
    String? shaftDiameter = this.shaftDiameter;
    String? shaftType = this.shaftType;
    String? mount = this.mount;
    String? led = this.led;
    attrs.forEach((k, v) {
      switch (k) {
        case Switch.typeKey:
          type = v;
        case Switch.polesKey:
          poles = int.parse(v);
        case Switch.switchingKey:
          switching = v;
        case Switch.positionsKey:
          positions = v != null ? int.parse(v) : null;
        case Switch.momentaryKey:
          momentary = v;
        case Switch.sizeKey:
          toggleSize = v;
        case Switch.bodySizeKey:
          bodySize = v;
        case Switch.shaftDiameterKey:
          shaftDiameter = v;
        case Switch.shaftTypeKey:
          shaftType = v;
        case Switch.mountKey:
          mount = v;
        case Switch.ledKey:
          led = v;
        default:
          debugPrint('unknown field $k');
      }
    });
    // clear things that don't make sense for whatever type is being done
    switch (type) {
      case 'Toggle':
        positions = null;
        bodySize = null;
        shaftType = null;
        shaftDiameter = null;
        mount = null;
        led = null;
      case 'Footswitch':
        positions = null;
        toggleSize = null;
        bodySize = null;
        shaftType = null;
        shaftDiameter = null;
        mount = null;
      case 'Rotary':
        switching = null;
        momentary = false;
        toggleSize = null;
        led = null;
      case 'DIP':
        switching = null;
        toggleSize = null;
        led = null;
      default:
        throw Exception("not this type $type");
    }
    final update = Switch(
      id: id,
      type: type,
      poles: poles,
      switching: switching,
      positions: positions,
      momentary: momentary,
      toggleSize: toggleSize,
      bodySize: bodySize,
      shaftDiameter: shaftDiameter,
      shaftType: shaftType,
      mount: mount,
      led: led,
    );
    return update;
  }

  static Component fromAttrs(String id, Map<String, dynamic> attrs) {
    return Switch(
      id: id,
      type: attrs[Switch.typeKey],
      poles: attrs[Switch.polesKey],
      switching: attrs[Switch.switchingKey],
      positions: attrs[Switch.positionsKey],
      momentary: attrs[Switch.momentaryKey] ?? false,
      toggleSize: attrs[Switch.sizeKey],
      bodySize: attrs[Switch.bodySizeKey],
      shaftDiameter: attrs[Switch.shaftDiameterKey],
      shaftType: attrs[Switch.shaftTypeKey],
      mount: attrs[Switch.mountKey],
      led: attrs[Switch.ledKey],
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'category': category.name,
      'quantity': quantity,
      'attrs': json.encode({
        typeKey: type,
        polesKey: poles,
        switchingKey: switching,
        positionsKey: positions,
        momentaryKey: momentary,
        sizeKey: toggleSize,
        bodySizeKey: bodySize,
        shaftDiameterKey: shaftDiameter,
        shaftTypeKey: shaftType,
        mountKey: mount,
        ledKey: led,
      }),
    };
  }
}
