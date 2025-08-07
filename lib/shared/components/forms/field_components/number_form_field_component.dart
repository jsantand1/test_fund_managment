import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';

/// Componente para campos numéricos
class NumberFormFieldComponent extends StatefulWidget {
  final FormFieldConfig field;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool hasError;
  final String? errorText;

  const NumberFormFieldComponent({
    super.key,
    required this.field,
    required this.controller,
    this.validator,
    this.onChanged,
    this.hasError = false,
    this.errorText,
  });

  @override
  State<NumberFormFieldComponent> createState() => _NumberFormFieldComponentState();
}

class _NumberFormFieldComponentState extends State<NumberFormFieldComponent> {
  @override
  void initState() {
    super.initState();
    
    // Limpiar cualquier carácter no válido del controlador
    final currentText = widget.controller.text;
    final cleanText = _cleanNumericText(currentText);
    
    if (currentText != cleanText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.text = cleanText;
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: cleanText.length),
        );
      });
    }
  }

  String _cleanNumericText(String text) {
    // Remover cualquier carácter que no sea número o punto decimal
    final cleaned = text.replaceAll(RegExp(r'[^0-9.]'), '');
    
    // Asegurar que solo haya un punto decimal
    final parts = cleaned.split('.');
    if (parts.length > 2) {
      return '${parts[0]}.${parts.sublist(1).join('')}';
    }
    
    return cleaned;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(widget.field.name),
      controller: widget.controller,
      enabled: widget.field.enabled,
      keyboardType: TextInputType.number,
      maxLength: widget.field.maxLength,
      validator: widget.validator,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.field.label + (widget.field.required ? ' *' : ''),
        hintText: widget.field.hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.hasError ? Colors.red : Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.hasError ? Colors.red : Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.hasError ? Colors.red : Colors.blue,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        errorText: widget.hasError ? widget.errorText : null,
        counterText: widget.field.maxLength != null ? null : '',
      ),
    );
  }
}
