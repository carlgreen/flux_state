import 'package:flutter/material.dart';
import 'package:flux_state/domain/models/component_category.dart';
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
  Map<String, dynamic> _attrs = {};

  final formKey = GlobalKey<FormState>();

  void _save() {
    if (!formKey.currentState!.validate()) return;
    widget.viewModel.save(_attrs, qty);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

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
            const _Label('CATEGORY'),
            const SizedBox(height: 10),
            _CategorySelector(
              selected: widget.viewModel.category,
              onChanged: (cat) => setState(() {
                widget.viewModel.category = cat;
                _attrs = {};
              }),
            ),
            const SizedBox(height: 28),

            const _Label('SPECIFICATIONS'),
            const SizedBox(height: 12),
            // fields,
            _ComponentAttrForm(
              // force reinit when category changes
              key: ValueKey(widget.viewModel.category),
              category: widget.viewModel.category,
              initialValues: _attrs,
              onChanged: (v) => setState(() => _attrs = v),
            ),

            const _Label('DETAILS'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Text(
                    'Quantity',
                    style: typography.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  QuantityStepper(
                    value: qty,
                    onChanged: (v) => setState(() => qty = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            const SizedBox(height: 20),
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

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.labelSmall?.copyWith(
        letterSpacing: 0.12,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ComponentAttrForm extends StatefulWidget {
  const _ComponentAttrForm({
    super.key,
    required this.category,
    required this.initialValues,
    required this.onChanged,
  });

  final ComponentCategory category;
  final Map<String, dynamic> initialValues;
  final ValueChanged<Map<String, dynamic>> onChanged;

  @override
  State<_ComponentAttrForm> createState() => _ComponentAttrFormState();
}

class _ComponentAttrFormState extends State<_ComponentAttrForm> {
  late Map<String, dynamic> _values;
  final Map<String, TextEditingController> _ctrl = {};

  @override
  void initState() {
    super.initState();
    _values = Map.from(widget.initialValues);
    _initControllers();
  }

  void _initControllers() {
    for (final f in _forCategory(widget.category)) {
      _ctrl[f.key] = TextEditingController(
        text: _values[f.key]?.toString() ?? '',
      );
    }
  }

  void _update(String key, dynamic value) {
    setState(() => _values[key] = value);
    widget.onChanged(Map<String, dynamic>.from(_values));
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final c in _ctrl.values) {
      c.dispose();
    }
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final fields = _forCategory(widget.category);
    if (fields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields
          .map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _textField(f),
            ),
          )
          .toList(),
    );
  }

  Widget _textField(_AttributeField field) {
    return TextFormField(
      controller: _ctrl[field.key],
      decoration: InputDecoration(hintText: field.label),
      keyboardType: TextInputType.number,
      onChanged: (v) => _update(field.key, v),
      validator: (field.type == _AttributeFieldType.number
          ? requiredIntValidator
          : requiredValidator)(field.label),
    );
  }
}

enum _AttributeFieldType { text, number }

class _AttributeField {
  final String key;
  final String label;
  final _AttributeFieldType type;

  _AttributeField({required this.key, required this.label, required this.type});
}

List<_AttributeField> _forCategory(ComponentCategory category) {
  return switch (category) {
    ComponentCategory.resistor => [
      _AttributeField(
        key: 'value',
        label: 'Value',
        type: _AttributeFieldType.number,
      ),
      _AttributeField(
        key: 'tolerance_pct',
        label: 'Tolerance',
        type: _AttributeFieldType.number,
      ),
      _AttributeField(
        key: 'power_w',
        label: 'Power',
        type: _AttributeFieldType.number,
      ),
    ],
    ComponentCategory.diode => [
      _AttributeField(
        key: 'code',
        label: 'Code',
        type: _AttributeFieldType.text,
      ),
    ],
  };
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
