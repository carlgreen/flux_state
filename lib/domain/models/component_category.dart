import 'package:flutter/material.dart';
import 'package:flux_state/theme/app_colors.dart';
import 'package:flux_state/ui/components_icons.dart';

enum ComponentCategory { resistor, capacitor, diode, led }

extension ComponentCategoryPresentation on ComponentCategory {
  String get displayName => switch (this) {
    ComponentCategory.resistor => 'Resistors',
    ComponentCategory.capacitor => 'Capacitors',
    ComponentCategory.diode => 'Diodes',
    ComponentCategory.led => 'LEDs',
  };

  String get singularName => switch (this) {
    ComponentCategory.resistor => 'Resistor',
    ComponentCategory.capacitor => 'Capacitor',
    ComponentCategory.diode => 'Diode',
    ComponentCategory.led => 'LED',
  };

  IconData get icon => switch (this) {
    ComponentCategory.resistor => ComponentIcons.resistor,
    ComponentCategory.capacitor => ComponentIcons.capacitor,
    ComponentCategory.diode => ComponentIcons.diode,
    ComponentCategory.led => ComponentIcons.led,
  };

  Color get color => switch (this) {
    ComponentCategory.resistor => AppColors.accentResistor,
    ComponentCategory.capacitor => AppColors.accentCapacitor,
    ComponentCategory.diode => AppColors.accentDiode,
    ComponentCategory.led => AppColors.accentLed,
  };

  bool get isHardware => switch (this) {
    // nothing yet!
    _ => false,
  };

  String get groupLabel => isHardware ? 'HARDWARE' : 'ELECTRONIC';
}
