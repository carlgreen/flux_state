import 'package:flutter/material.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';
import 'package:flux_state/ui/component_catalog/quantity_stepper.dart';

class AddEditComponentScreen extends StatefulWidget {
  const AddEditComponentScreen({super.key, required this.viewModel});

  final AddEditComponentViewModel viewModel;

  @override
  State<AddEditComponentScreen> createState() => _AddEditComponentScreenState();
}

class _AddEditComponentScreenState extends State<AddEditComponentScreen> {
  int qty = 0;

  final formKey = GlobalKey<FormState>();

  late _ComponentFields fields;

  @override
  void initState() {
    super.initState();
    _updateFields();
  }

  void _updateFields() {
    fields = switch (widget.viewModel.category) {
      ComponentCategory.resistor => _ResistorFields(),
      ComponentCategory.diode => _DiodeFields(),
    };
  }

  void _save() {
    if (!formKey.currentState!.validate()) return;
    widget.viewModel.save(fields.component, qty);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('NEW_COMPONENT'),
        actions: [TextButton(onPressed: _save, child: const Text('SAVE'))],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
          children: [
            _CategorySelector(
              selected: widget.viewModel.category,
              onChanged: (cat) => setState(() {
                widget.viewModel.category = cat;
                _updateFields();
              }),
            ),
            Row(
              children: [
                const Text('Quantity'),
                const Spacer(),
                QuantityStepper(
                  value: qty,
                  onChanged: (v) => setState(() => qty = v),
                ),
              ],
            ),
            fields,
            _SaveButton(onTap: _save),
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.selected, required this.onChanged});

  final ComponentCategory selected;
  final ValueChanged<ComponentCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ComponentCategory.values.map((cat) {
        final sel = cat == selected;
        return GestureDetector(
          onTap: () => onChanged(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: sel
                  ? cat.color.withValues(alpha: 0.18)
                  : colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
              border: sel
                  ? Border.all(
                      color: cat.color.withValues(alpha: 0.45),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  cat.icon,
                  size: 13,
                  color: sel ? cat.color : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  cat.singularName.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: sel ? cat.color : colors.onSurfaceVariant,
                    fontSize: 10,
                    letterSpacing: 0.06,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, colors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: null,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'SAVE COMPONENT',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colors.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

abstract class _ComponentFields extends StatefulWidget {
  String get text;
  dynamic get component;
}

class _ResistorFields extends _ComponentFields {
  _ResistorFields();

  final valueCtrl = TextEditingController();
  final powerCtrl = TextEditingController();
  final toleranceCtrl = TextEditingController();

  @override
  String get text =>
      '${valueCtrl.text} ${powerCtrl.text} (${toleranceCtrl.text})';

  @override
  get component => Resistor(
    value: int.parse(valueCtrl.text),
    tolerance: int.parse(toleranceCtrl.text),
    power: int.parse(powerCtrl.text),
  );

  @override
  State<_ResistorFields> createState() => _ResistorFieldsState();
}

class _ResistorFieldsState extends State<_ResistorFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.valueCtrl,
          decoration: const InputDecoration(hintText: 'Value'),
          keyboardType: TextInputType.number,
          validator: requiredIntValidator('Value'),
        ),
        TextFormField(
          controller: widget.powerCtrl,
          decoration: const InputDecoration(hintText: 'Power'),
          keyboardType: TextInputType.number,
          validator: requiredIntValidator('Power'),
        ),
        TextFormField(
          controller: widget.toleranceCtrl,
          decoration: const InputDecoration(hintText: 'Tolerance'),
          keyboardType: TextInputType.number,
          validator: requiredIntValidator('Tolerance'),
        ),
      ],
    );
  }
}

class _DiodeFields extends _ComponentFields {
  _DiodeFields();

  final codeCtrl = TextEditingController();

  @override
  String get text => codeCtrl.text;

  @override
  get component => Diode(code: codeCtrl.text);

  @override
  State<_DiodeFields> createState() => _DiodeFieldsState();
}

class _DiodeFieldsState extends State<_DiodeFields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.codeCtrl,
      decoration: const InputDecoration(hintText: 'Code'),
      validator: requiredValidator('Code'),
    );
  }
}

FormFieldValidator<String>? requiredValidator(String field) {
  return (v) {
    if (v == null || v.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  };
}

FormFieldValidator<String>? requiredIntValidator(String field) {
  return (v) {
    if (v == null || v.trim().isEmpty) {
      return '$field is required';
    }
    if (int.tryParse(v) == null) {
      return '$field must be a number';
    }
    return null;
  };
}
