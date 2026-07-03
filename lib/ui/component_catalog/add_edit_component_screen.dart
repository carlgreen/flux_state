import 'package:flutter/material.dart';
import 'package:flux_state/domain/models/diode.dart';
import 'package:flux_state/domain/models/resistor.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';

class AddEditComponentScreen extends StatefulWidget {
  const AddEditComponentScreen({super.key, required this.viewModel});

  final AddEditComponentViewModel viewModel;

  @override
  State<AddEditComponentScreen> createState() => _AddEditComponentScreenState();
}

class _AddEditComponentScreenState extends State<AddEditComponentScreen> {
  final formKey = GlobalKey<FormState>();

  final quantityCtrl = TextEditingController(text: 0.toString());

  late _ComponentFields? fields;

  @override
  void initState() {
    super.initState();
    fields = switch (widget.viewModel.componentType) {
      'Resistors' => _ResistorFields(),
      'Diodes' => _DiodeFields(),
      _ => null,
    };
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
        actions: [
          TextButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              widget.viewModel.save(
                fields?.component,
                int.parse(quantityCtrl.text),
              );
              Navigator.pop(context, true);
            },
            child: const Text('SAVE'),
          ),
        ],
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
              validator: requiredIntValidator('Quantity'),
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
