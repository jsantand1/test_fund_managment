import 'package:flutter/material.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';

/// Componente para campos dropdown
class DropdownFormFieldComponent extends StatelessWidget {
  final FormFieldConfig field;
  final dynamic value;
  final String? Function(dynamic)? validator;
  final Function(dynamic)? onChanged;

  const DropdownFormFieldComponent({
    super.key,
    required this.field,
    this.value,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: ValueKey(field.name),
      value: value,
      items: _buildDropdownItems(),
      onChanged: field.enabled ? (String? newValue) {
        onChanged?.call(newValue);
      } : null,
      validator: validator,
      decoration: InputDecoration(
        labelText: field.label + (field.required ? ' *' : ''),
        hintText: field.hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    if (field.selectOptions != null) {
      return field.selectOptions!
          .map((option) => DropdownMenuItem<String>(
                value: option.value,
                child: Text(option.label),
              ))
          .toList();
    }
    return [];
  }
}
