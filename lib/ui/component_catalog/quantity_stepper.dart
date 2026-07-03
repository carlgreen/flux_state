import 'package:flutter/material.dart';

class QuantityStepper extends StatefulWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  late TextEditingController _ctrl;
  late int _val;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
    _ctrl = TextEditingController(text: _val.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _set(int v) {
    final clamped = v < 0 ? 0 : v;
    setState(() => _val = clamped);
    _ctrl.text = clamped.toString();
    widget.onChanged(clamped);
  }

  void _onTextChanged(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed != null) {
      _set(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepBtn(icon: Icons.remove_rounded, onPressed: () => _set(_val - 1)),
        const SizedBox(width: 8),
        SizedBox(
          width: 72,
          child: TextFormField(
            controller: _ctrl,
            keyboardType: TextInputType.number,
            validator: _requiredIntValidator(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              isDense: true,
            ),
            onChanged: _onTextChanged,
          ),
        ),
        const SizedBox(width: 8),
        _StepBtn(icon: Icons.add_rounded, onPressed: () => _set(_val + 1)),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface, size: 20),
      ),
    );
  }
}

FormFieldValidator<String>? _requiredIntValidator() {
  return (v) {
    if (v == null || v.trim().isEmpty) {
      return 'Quantity is required';
    }
    if (int.tryParse(v) == null) {
      return 'Quantity must be a number';
    }
    return null;
  };
}
