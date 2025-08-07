import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_fund_managment/shared/models/form_field_config.dart';
import 'package:test_fund_managment/shared/models/validator.dart';
import 'field_components/field_components.dart';

// Enum para tipos de campos
enum FieldType {
  text,
  number,
  email,
  phone,
  phoneWithCountry,
  password,
  select,
  checkbox,
  radio,
}

// Opción para select
class SelectOption {
  final String value;
  final String label;

  const SelectOption({required this.value, required this.label});
}

/// Callback para cuando cambian los valores del formulario
typedef FormValueChanged = void Function(Map<String, String> values);

/// Un componente de formulario dinámico que genera campos basados en una configuración
class DynamicForm extends StatefulWidget {
  /// Lista de configuraciones de campos para generar el formulario
  final List<FormFieldConfig> fields;

  /// Espacio vertical entre campos
  final double fieldSpacing;

  /// Callback que se ejecuta cuando algún valor cambia
  final FormValueChanged? onChanged;

  /// Valores iniciales para los campos (opcional)
  final Map<String, String>? initialValues;

  /// Habilita validación en tiempo real mientras el usuario escribe
  final bool enableReactiveValidation;

  /// Constructor
  const DynamicForm({
    super.key,
    required this.fields,
    this.fieldSpacing = 16.0,
    this.onChanged,
    this.initialValues,
    this.enableReactiveValidation = true,
  });

  @override
  State<DynamicForm> createState() => DynamicFormState();
}

class DynamicFormState extends State<DynamicForm> {
  /// Mapa de controladores para cada campo de texto
  final Map<String, TextEditingController> _controllers = {};

  /// Mapa de valores booleanos para checkboxes
  final Map<String, bool> _checkboxValues = {};

  /// Mapa de valores actuales (texto y booleanos convertidos a string)
  late Map<String, String> _formValues;

  /// Mapa para seguimiento de errores de campos
  final Map<String, bool> _fieldErrors = {};

  @override
  void initState() {
    super.initState();

    // Inicializa los valores del formulario
    _formValues = widget.initialValues != null
        ? Map<String, String>.from(widget.initialValues!)
        : {};

    // Crea los controladores y establece los valores iniciales para cada campo
    for (final field in widget.fields) {
      // Inicializa el estado de error
      _fieldErrors[field.name] = false;

      // Si es tipo checkbox, manejar como boolean
      if (field.type == FieldType.checkbox) {
        // Obtener valor inicial (convertir string 'true'/'false' a boolean)
        final initialBoolValue =
            widget.initialValues?[field.name] == 'true' ||
            (field.initialValue == 'true');

        // Guardar valor del checkbox
        _checkboxValues[field.name] = initialBoolValue;

        // Asegurarse de que el valor esté en _formValues como string
        if (!_formValues.containsKey(field.name)) {
          _formValues[field.name] = initialBoolValue.toString();
        }
      }
      // Para otros tipos de campos que usan TextEditingController
      else {
        // Define el valor inicial desde los initialValues o desde la config del campo
        final initialValue =
            widget.initialValues?[field.name] ?? field.initialValue ?? '';

        // Crea y guarda el controlador con el valor inicial
        _controllers[field.name] = TextEditingController(text: initialValue);

        // Asegúrate de que el valor esté en _formValues
        if (!_formValues.containsKey(field.name)) {
          _formValues[field.name] = initialValue;
        }
      }
    }
  }

  @override
  void dispose() {
    // Limpia los controladores
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Obtiene los valores actuales del formulario
  Map<String, String> get values => _formValues;

  /// Verifica si el formulario tiene algún error
  bool get hasErrors => _fieldErrors.values.contains(true);

  /// Actualiza el valor de un campo específico (solo para campos de texto)
  void updateField(String fieldName, String value) {
    if (_controllers.containsKey(fieldName)) {
      // Actualiza el controller si su valor actual es diferente
      if (_controllers[fieldName]!.text != value) {
        _controllers[fieldName]!.text = value;
      }

      // Actualiza el valor en el mapa
      _formValues[fieldName] = value;

      // Notifica el cambio
      if (widget.onChanged != null) {
        widget.onChanged!(_formValues);
      }
    }
  }

  /// Actualiza el valor de cualquier campo del formulario
  /// independientemente de su tipo (texto, checkbox, select, etc)
  /// @param fieldName Nombre del campo a actualizar
  /// @param value Valor a establecer (para checkbox debe ser 'true' o 'false')
  void setValue(String fieldName, String value) {
    final fieldConfig = widget.fields.firstWhere(
      (f) => f.name == fieldName,
      orElse: () => throw Exception('Campo no encontrado: $fieldName'),
    );

    // Manejo según el tipo de campo
    if (fieldConfig.type == FieldType.checkbox) {
      // Convertir string a bool para checkbox
      final boolValue = value.toLowerCase() == 'true';

      setState(() {
        // Actualizar el valor en el mapa de checkboxes
        _checkboxValues[fieldName] = boolValue;

        // Actualizar en el mapa de valores del formulario
        _formValues[fieldName] = value;
      });

      // Llamar al onChanged específico del campo si existe
      if (fieldConfig.onChanged != null) {
        fieldConfig.onChanged!(value);
      }
    } else if (fieldConfig.type == FieldType.phoneWithCountry) {
      // Para teléfonos con país, solo actualizamos el valor del teléfono
      // El país debe actualizarse por separado
      setState(() {
        _formValues[fieldName] = value;
      });
    } else if (fieldConfig.type == FieldType.select) {
      // Para selects, solo actualizamos el valor en el mapa
      setState(() {
        _formValues[fieldName] = value;
      });
    } else {
      // Para campos de texto y otros tipos con controladores
      if (_controllers.containsKey(fieldName)) {
        // Actualiza el controller si su valor actual es diferente
        if (_controllers[fieldName]!.text != value) {
          _controllers[fieldName]!.text = value;
        }

        // Actualizar en el mapa de valores del formulario
        _formValues[fieldName] = value;
      }
    }

    // Notificar el cambio general del formulario
    if (widget.onChanged != null) {
      widget.onChanged!(_formValues);
    }
  }

  // Mapa para almacenar las referencias a los campos de formulario
  final Map<String, GlobalKey<FormFieldState>> _fieldKeys = {};

  /// Valida todo el formulario y devuelve si es válido
  bool validate() {
    bool isValid = true;

    for (final field in widget.fields) {
      bool fieldValid = true;

      // Validación especial para phoneWithCountry
      if (field.type == FieldType.phoneWithCountry) {
        // Obtenemos la key del campo si existe
        if (_fieldKeys.containsKey(field.name) &&
            _fieldKeys[field.name]?.currentState != null) {
          // Validamos directamente el campo usando su método validate()
          fieldValid = _fieldKeys[field.name]!.currentState!.validate();
        } else {
          // Si no tenemos referencia al campo, hacemos validación estándar
          final value = _formValues[field.name] ?? '';

          // Verifica si es requerido
          if (field.required && value.isEmpty) {
            fieldValid = false;
          }

          // Verifica validadores personalizados del teléfono
          if (fieldValid && field.phoneValidators != null) {
            for (final validator in field.phoneValidators!) {
              if (!validator.isValid(value, allValues: _formValues)) {
                fieldValid = false;
                break;
              }
            }
          }
        }
      } else {
        // Para los demás tipos de campos, validación normal
        final value = _formValues[field.name] ?? '';

        // Verifica si es requerido
        if (field.required && value.isEmpty) {
          fieldValid = false;
        }

        // Verifica validadores personalizados
        if (fieldValid && field.validators != null) {
          for (final validator in field.validators!) {
            if (!validator.isValid(value, allValues: _formValues)) {
              fieldValid = false;
              break;
            }
          }
        }
      }

      // Actualiza el mapa de errores
      setState(() {
        _fieldErrors[field.name] = !fieldValid;
      });

      // Actualiza el estado general del formulario
      if (!fieldValid) {
        isValid = false;
      }
    }

    return isValid;
  }

  /// Obtiene los validadores para un campo específico
  List<Validator> _getValidators(FormFieldConfig field) {
    final validators = <Validator>[];
    // Agrega cualquier validador adicional proporcionado en la configuración
    if (field.validators != null) {
      validators.addAll(field.validators!);
    }
    return validators;
  }

  /// Valida un campo específico en tiempo real
  String? _validateField(FormFieldConfig field, String value) {
    // Validación de campo requerido
    if (field.required && (value.isEmpty || value.trim().isEmpty)) {
      return '${field.label} es requerido';
    }

    // Validación de tipo número
    if (field.type == FieldType.number && value.isNotEmpty) {
      if (double.tryParse(value) == null) {
        return 'Ingrese un número válido';
      }
    }

    // Validaciones personalizadas
    if (field.validators != null) {
      for (final validator in field.validators!) {
        final isValid = validator.isValid(value, allValues: _formValues);
        if (!isValid) {
          return validator.errorMessage;
        }
      }
    }

    return null;
  }

  /// Maneja el cambio de valor de un campo de texto
  void _handleFieldChanged(String fieldName, String value) {
    // Actualiza el valor en el mapa
    _formValues[fieldName] = value;

    // Validación reactiva si está habilitada
    if (widget.enableReactiveValidation) {
      final fieldConfig = widget.fields.firstWhere(
        (f) => f.name == fieldName,
        orElse: () => widget.fields.first,
      );

      final error = _validateField(fieldConfig, value);
      setState(() {
        _fieldErrors[fieldName] = error != null;
      });
    }

    // Notifica el cambio
    if (widget.onChanged != null) {
      widget.onChanged!(_formValues);
    }

    // Llama al onChanged específico del campo si existe
    final fieldConfig = widget.fields.firstWhere(
      (f) => f.name == fieldName,
      orElse: () => widget.fields.first,
    );

    if (fieldConfig.onChanged != null) {
      fieldConfig.onChanged!(value);
    }
  }

  /// Maneja el cambio de valor de un checkbox
  void _handleCheckboxChanged(String fieldName, bool value) {
    // Actualiza el valor en el mapa de checkboxes
    _checkboxValues[fieldName] = value;

    // Actualiza el valor como string en el mapa de valores del formulario
    _formValues[fieldName] = value.toString();

    // Notifica el cambio
    if (widget.onChanged != null) {
      widget.onChanged!(_formValues);
    }

    // Llama al onChanged específico del campo si existe
    final fieldConfig = widget.fields.firstWhere(
      (f) => f.name == fieldName,
      orElse: () => widget.fields.first,
    );

    if (fieldConfig.onChanged != null) {
      fieldConfig.onChanged!(value.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.map((field) {
        // Crea el widget según el tipo de campo
        Widget fieldWidget;

        // Obtener información de error para el campo actual
        final hasFieldError = _fieldErrors[field.name] ?? false;
        final fieldErrorText = hasFieldError
            ? _validateField(field, _formValues[field.name] ?? '')
            : null;

        switch (field.type) {
          case FieldType.checkbox:
            fieldWidget = CheckboxFormFieldComponent(
              field: field,
              value: _checkboxValues[field.name] ?? false,
              onChanged: (value) =>
                  _handleCheckboxChanged(field.name, value ?? false),
            );
            break;

          case FieldType.number:
            fieldWidget = NumberFormFieldComponent(
              field: field,
              controller: _controllers[field.name]!,
              validator: (value) => _validateField(field, value ?? ''),
              onChanged: (value) => _handleFieldChanged(field.name, value),
              hasError: hasFieldError,
              errorText: fieldErrorText,
            );
            break;

          case FieldType.select:
            fieldWidget = DropdownFormFieldComponent(
              field: field,
              value: _formValues[field.name],
              onChanged: (value) =>
                  _handleFieldChanged(field.name, value ?? ''),
            );
            break;

          case FieldType.radio:
            fieldWidget = RadioFormFieldComponent(
              field: field,
              value: _formValues[field.name],
              onChanged: (value) =>
                  _handleFieldChanged(field.name, value ?? ''),
            );
            break;

          case FieldType.text:
          default:
            fieldWidget = TextFormFieldComponent(
              field: field,
              controller: _controllers[field.name]!,
              validator: (value) => _validateField(field, value ?? ''),
              onChanged: (value) => _handleFieldChanged(field.name, value),
              hasError: hasFieldError,
              errorText: fieldErrorText,
            );
            break;
        }

        return Padding(
          padding: EdgeInsets.only(bottom: widget.fieldSpacing),
          child: fieldWidget,
        );
      }).toList(),
    );
  }
}
