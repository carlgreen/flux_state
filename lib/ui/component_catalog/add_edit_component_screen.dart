import 'package:flutter/material.dart';
import 'package:flux_state/core/component_schemas.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/theme/app_colors.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';
import 'package:flux_state/ui/component_catalog/quantity_stepper.dart';

class AddEditComponentScreen extends StatefulWidget {
  const AddEditComponentScreen({super.key, required this.viewModel});

  final AddEditComponentViewModel viewModel;

  @override
  State<AddEditComponentScreen> createState() => _AddEditComponentScreenState();
}

class _AddEditComponentScreenState extends State<AddEditComponentScreen> {
  final formKey = GlobalKey<FormState>();

  int qty = 0;
  Map<String, dynamic> _attrs = {};
  bool _isSaving = false;
  bool _initialized = false;

  bool get _isEditing => widget.viewModel.componentId != null;

  void _populate(Component c) {
    widget.viewModel.category = c.category;
    qty = c.quantity;
    _attrs = Map<String, dynamic>.from(c.attributes);
    _initialized = true;
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      if (_isEditing) {
        final existing = widget.viewModel.component;
        if (existing == null) {
          debugPrint('no component to edit');
          return;
        }
        await widget.viewModel.update(existing.id, _attrs, qty);
      } else {
        await widget.viewModel.save(_attrs, qty);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
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
        title: Text(
          _isEditing ? 'EDIT_COMPONENT' : 'NEW_COMPONENT',
          style: typography.labelLarge?.copyWith(color: colors.primary),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(
                'SAVE',
                style: typography.labelLarge?.copyWith(color: colors.primary),
              ),
            ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            if (_isEditing && !_initialized) {
              final comp = widget.viewModel.component;
              if (comp != null && !_initialized) {
                _populate(comp);
              }
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
              children: [
                if (!_isEditing) ...[
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
                ],

                const _Label('SPECIFICATIONS'),
                const SizedBox(height: 12),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
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
                _SaveButton(saving: _isSaving, onTap: _save),
              ],
            );
          },
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
  const _SaveButton({required this.saving, required this.onTap});
  final bool saving;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: saving ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: saving ? null : AppColors.primaryGradient,
          color: saving ? colors.surfaceContainerHigh : null,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: saving
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.onPrimaryContainer,
                ),
              )
            : Text(
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
    for (final f in ComponentSchemas.forCategory(widget.category)) {
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

  /// Returns true when all showWhen conditions are satisfied.
  bool _shouldShow(AttributeField field) {
    final conditions = field.showWhen;
    for (final entry in conditions.entries) {
      final current = _values[entry.key]?.toString();
      if (current == null || !entry.value.contains(current)) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final fields = ComponentSchemas.forCategory(widget.category);
    if (fields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields
          .where(_shouldShow)
          .map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildField(f),
            ),
          )
          .toList(),
    );
  }

  Widget _buildField(AttributeField field) {
    return switch (field.type) {
      AttributeFieldType.text || AttributeFieldType.number => _textField(field),
      AttributeFieldType.dropdown => _dropdown(field),
      AttributeFieldType.boolean => _booleanField(field),
    };
  }

  Widget _textField(AttributeField field) {
    return TextFormField(
      controller: _ctrl[field.key],
      decoration: InputDecoration(
        labelText: field.unit != null
            ? '${field.label} (${field.unit})'
            : field.label,
        hintText: field.hint,
      ),
      keyboardType: switch (field.type) {
        AttributeFieldType.number => const TextInputType.numberWithOptions(
          decimal: true,
        ),
        _ => TextInputType.text,
      },
      textCapitalization: TextCapitalization.words,
      onChanged: (v) => _update(field.key, v),
      validator: (field.type == AttributeFieldType.number
          ? (field.required ? requiredNumberValidator : numberValidator)
          : (field.required ? requiredValidator : (v) => null))(field.label),
    );
  }

  Widget _dropdown(AttributeField field) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    final current = _values[field.key]?.toString();
    final opts = field.options ?? [];
    if (!field.required) {
      opts.insert(0, '');
    }
    final value = opts.contains(current) ? current : null;

    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: colors.surfaceContainerHighest,
      style: typography.bodyMedium?.copyWith(color: colors.onSurface),
      iconEnabledColor: colors.onSurfaceVariant,
      decoration: InputDecoration(
        labelText: field.unit != null
            ? '${field.label} (${field.unit})'
            : field.label,
      ),
      isExpanded: true,
      items: opts
          .map(
            (o) => DropdownMenuItem(
              value: o,
              child: Text(
                o,
                style: typography.bodyMedium?.copyWith(color: colors.onSurface),
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) _update(field.key, v);
      },
      validator: field.required ? requiredValidator(field.label) : null,
    );
  }

  Widget _booleanField(AttributeField field) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;

    final current = _values[field.key] as bool? ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(field.label, style: typography.bodyMedium),
        Switch(value: current, onChanged: (v) => _update(field.key, v)),
      ],
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

FormFieldValidator<String>? numberValidator(String field) {
  return (v) {
    if (v == null || v.trim().isEmpty) {
      return null;
    }
    if (double.tryParse(v) == null) {
      return '$field must be a number';
    }
    return null;
  };
}

FormFieldValidator<String>? requiredNumberValidator(String field) {
  return (v) {
    if (v == null || v.trim().isEmpty) {
      return '$field is required';
    }
    if (double.tryParse(v) == null) {
      return '$field must be a number';
    }
    return null;
  };
}
