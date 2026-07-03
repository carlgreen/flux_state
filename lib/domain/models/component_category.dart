import 'package:flutter/material.dart';
import 'package:flux_state/ui/components_icons.dart';

enum ComponentCategory { resistor, diode }

extension ComponentCategoryPresentation on ComponentCategory {
  static const Color accentResistor = Color(0xFFFFB547);
  static const Color accentDiode = Color(0xFF34D399);

  String get singularName => switch (this) {
    ComponentCategory.resistor => 'Resistor',
    ComponentCategory.diode => 'Diode',
  };

  IconData get icon => switch (this) {
    ComponentCategory.resistor => ComponentIcons.resistor,
    ComponentCategory.diode => ComponentIcons.diode,
  };

  Color get color => switch (this) {
    ComponentCategory.resistor => accentResistor,
    ComponentCategory.diode => accentDiode,
  };
}
