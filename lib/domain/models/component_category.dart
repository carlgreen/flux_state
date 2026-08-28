import 'package:flutter/material.dart';
import 'package:flux_state/theme/app_colors.dart';
import 'package:flux_state/ui/components_icons.dart';

enum ComponentCategory {
  resistor,
  capacitor,
  diode,
  led,
  transistor,
  ic,
  potentiometer,
}

extension ComponentCategoryPresentation on ComponentCategory {
  String get displayName => switch (this) {
    ComponentCategory.resistor => 'Resistors',
    ComponentCategory.capacitor => 'Capacitors',
    ComponentCategory.diode => 'Diodes',
    ComponentCategory.led => 'LEDs',
    ComponentCategory.transistor => 'Transistors',
    ComponentCategory.ic => 'ICs',
    ComponentCategory.potentiometer => 'Pots',
  };

  String get singularName => switch (this) {
    ComponentCategory.resistor => 'Resistor',
    ComponentCategory.capacitor => 'Capacitor',
    ComponentCategory.diode => 'Diode',
    ComponentCategory.led => 'LED',
    ComponentCategory.transistor => 'Transistor',
    ComponentCategory.ic => 'IC',
    ComponentCategory.potentiometer => 'Pot',
  };

  IconData get icon => switch (this) {
    ComponentCategory.resistor => ComponentIcons.resistor,
    ComponentCategory.capacitor => ComponentIcons.capacitor,
    ComponentCategory.diode => ComponentIcons.diode,
    ComponentCategory.led => ComponentIcons.led,
    ComponentCategory.transistor => ComponentIcons.transistor,
    ComponentCategory.ic => ComponentIcons.ic,
    ComponentCategory.potentiometer => ComponentIcons.potentiometer,
  };

  Color get color => switch (this) {
    ComponentCategory.resistor => AppColors.accentResistor,
    ComponentCategory.capacitor => AppColors.accentCapacitor,
    ComponentCategory.diode => AppColors.accentDiode,
    ComponentCategory.led => AppColors.accentLed,
    ComponentCategory.transistor => AppColors.accentTransistor,
    ComponentCategory.ic => AppColors.accentIc,
    ComponentCategory.potentiometer => AppColors.accentPotentiometer,
  };

  bool get isHardware => switch (this) {
    // nothing yet!
    _ => false,
  };

  String get groupLabel => isHardware ? 'HARDWARE' : 'ELECTRONIC';
}
