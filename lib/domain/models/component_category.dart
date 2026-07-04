import 'package:flutter/material.dart';
import 'package:flux_state/theme/app_colors.dart';
import 'package:flux_state/ui/components_icons.dart';

enum ComponentCategory { resistor, diode }

extension ComponentCategoryPresentation on ComponentCategory {
  String get displayName => switch (this) {
    ComponentCategory.resistor => 'Resistors',
    ComponentCategory.diode => 'Diodes',
  };

  String get singularName => switch (this) {
    ComponentCategory.resistor => 'Resistor',
    ComponentCategory.diode => 'Diode',
  };

  IconData get icon => switch (this) {
    ComponentCategory.resistor => ComponentIcons.resistor,
    ComponentCategory.diode => ComponentIcons.diode,
  };

  Color get color => switch (this) {
    ComponentCategory.resistor => AppColors.accentResistor,
    ComponentCategory.diode => AppColors.accentDiode,
  };

  bool get isHardware => switch (this) {
    // nothing yet!
    _ => false,
  };

  String get groupLabel => isHardware ? 'HARDWARE' : 'ELECTRONIC';
}
