import 'package:flutter/material.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';

/// Componente para campos checkbox
class CheckboxFormFieldComponent extends StatelessWidget {
  final FormFieldConfig field;
  final bool value;
  final String? Function(bool?)? validator;
  final Function(bool)? onChanged;

  const CheckboxFormFieldComponent({
    super.key,
    required this.field,
    required this.value,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      key: ValueKey(field.name),
      initialValue: value,
      validator: validator,
      builder: (FormFieldState<bool> state) {
        return CheckboxListTile(
          title: Text(field.label + (field.required ? ' *' : '')),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (field.hintText != null) Text(field.hintText!),
              if (state.hasError)
                Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          value: value,
          onChanged: field.enabled ? (bool? newValue) {
            final boolValue = newValue ?? false;
            onChanged?.call(boolValue);
            state.didChange(boolValue);
          } : null,
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }
}
