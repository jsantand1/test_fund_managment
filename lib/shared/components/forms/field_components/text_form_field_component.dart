import 'package:flutter/material.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';

/// Componente para campos de texto
class TextFormFieldComponent extends StatelessWidget {
  final FormFieldConfig field;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool hasError;
  final String? errorText;

  const TextFormFieldComponent({
    super.key,
    required this.field,
    required this.controller,
    this.validator,
    this.onChanged,
    this.hasError = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(field.name),
      controller: controller,
      enabled: field.enabled,
      keyboardType: TextInputType.text,
      maxLength: field.maxLength,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: field.label + (field.required ? ' *' : ''),
        hintText: field.hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.blue,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorText: hasError ? errorText : null,
        counterText: field.maxLength != null ? null : '',
      ),
    );
  }
}
