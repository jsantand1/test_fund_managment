import 'package:flutter/material.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';

/// Componente para campos radio
class RadioFormFieldComponent extends StatelessWidget {
  final FormFieldConfig field;
  final String? value;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  const RadioFormFieldComponent({
    super.key,
    required this.field,
    this.value,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: ValueKey(field.name),
      initialValue: value,
      validator: validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              field.label + (field.required ? ' *' : ''),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),

            // Hint text
            if (field.hintText != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  field.hintText!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),

            if (field.hintText != null) const SizedBox(height: 8),

            // Radio options
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.hasError
                      ? Theme.of(context).colorScheme.error
                      : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children:
                    field.selectOptions
                        ?.map(
                          (option) => RadioListTile<String>(
                            title: Text(option.label),
                            value: option.value,
                            groupValue: value,
                            onChanged: field.enabled
                                ? (String? newValue) {
                                    onChanged?.call(newValue);
                                    state.didChange(newValue);
                                  }
                                : null,
                            dense: true,
                          ),
                        )
                        .toList() ??
                    [],
              ),
            ),

            // Error message
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
