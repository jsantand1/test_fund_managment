// Configuración de un campo del formulario
import 'package:flutter/material.dart';
import 'package:test_fund_managment/shared/components/components.dart';
import 'package:test_fund_managment/shared/models/validator.dart';

class FormFieldConfig {
  final String name;
  final String label;
  final FieldType type;
  final bool required;
  final String? hintText;
  final String? helperText;
  final String? initialValue;
  final bool enabled;
  final int? maxLength;
  final Widget? suffixIcon;
  final List<Validator>? validators;
  final void Function(String)? onChanged;
  
  // Para select
  final List<SelectOption>? selectOptions;
  
  final String? countryCode;
  final String? phoneLabel;
  final String? phoneHelperText;
  final String? phoneHintText;
  final List<Validator>? phoneValidators;

  const FormFieldConfig({
    required this.name,
    required this.label,
    required this.type,
    this.required = false,
    this.hintText,
    this.helperText,
    this.initialValue,
    this.enabled = true,
    this.maxLength,
    this.suffixIcon,
    this.validators,
    this.onChanged,
    this.selectOptions,
    this.countryCode,
    this.phoneLabel,
    this.phoneHelperText,
    this.phoneHintText,
    this.phoneValidators,
  });

  // Constructor de conveniencia para mantener compatibilidad
  factory FormFieldConfig.legacy({
    required String key,
    required String label,
    required FieldType type,
    bool required = false,
    String? hint,
    dynamic defaultValue,
    List<String>? options,
    Map<String, String>? optionsMap,
    bool enabled = true,
    int? maxLength,
    String? pattern,
    String? errorMessage,
  }) {
    return FormFieldConfig(
      name: key,
      label: label,
      type: type,
      required: required,
      hintText: hint,
      initialValue: defaultValue?.toString(),
      enabled: enabled,
      maxLength: maxLength,
      selectOptions: options?.map((o) => SelectOption(value: o, label: o)).toList(),
    );
  }
}
