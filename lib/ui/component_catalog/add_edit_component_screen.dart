import 'package:flutter/material.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';

class AddEditComponentScreen extends StatelessWidget {
  const AddEditComponentScreen({super.key, required this.viewModel});

  final AddEditComponentViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final quantityCtrl = TextEditingController(text: 0.toString());

    final fields = switch (viewModel.componentType) {
      'Resistors' => _ResistorFields(),
      'Diodes' => _DiodeFields(),
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Component'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            ?fields,
            TextFormField(
              controller: quantityCtrl,
              decoration: const InputDecoration(hintText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Quantity is required';
                }
                if (int.tryParse(v) == null) {
                  return 'Quantity must be a number';
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () {
                viewModel.save(fields?.component, int.parse(quantityCtrl.text));
                Navigator.pop(context, true);
              },
              child: const Text('Save'),
            ),
          ],
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
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Value is required' : null,
        ),
        TextFormField(
          controller: widget.powerCtrl,
          decoration: const InputDecoration(hintText: 'Power'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Power is required' : null,
        ),
        TextFormField(
          controller: widget.toleranceCtrl,
          decoration: const InputDecoration(hintText: 'Tolerance'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Tolerance is required' : null,
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
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? 'Code is required' : null,
    );
  }
}
