import 'package:test_fund_managment/shared/models/validator.dart';



/// Clase que contiene validadores comunes para formularios
class FormValidators {
  /// Valida que un campo no esté vacío
  static Validator required({String message = 'Este campo es obligatorio'}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.trim().isNotEmpty,
      errorMessage: message,
    );
  }

  /// Valida una dirección de correo electrónico
  static Validator email({String message = 'Ingrese un correo electrónico válido'}) {
    // Expresión regular para validar emails
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || emailRegex.hasMatch(value),
      errorMessage: message,
    );
  }

  /// Valida que un campo tenga una longitud mínima
  static Validator minLength(int length, {String? message}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || value.length >= length,
      errorMessage: message ?? 'Debe tener al menos $length caracteres',
    );
  }

  /// Valida que un campo tenga una longitud máxima
  static Validator maxLength(int length, {String? message}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || value.length <= length,
      errorMessage: message ?? 'No debe exceder $length caracteres',
    );
  }

  /// Valida que un campo tenga un valor numérico
  static Validator numeric({String message = 'Debe ser un número válido'}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || double.tryParse(value) != null,
      errorMessage: message,
    );
  }

  /// Valida que un campo contenga solo dígitos
  static Validator digits({String message = 'Debe contener solo dígitos'}) {
    final RegExp digitsOnly = RegExp(r'^\d+$');
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || digitsOnly.hasMatch(value),
      errorMessage: message,
    );
  }

  /// Valida que un campo contenga solo letras
  static Validator alpha({String message = 'Debe contener solo letras'}) {
    final RegExp lettersOnly = RegExp(r'^[a-zA-Z]+$');
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || lettersOnly.hasMatch(value),
      errorMessage: message,
    );
  }

  /// Valida que un campo contenga letras y números
  static Validator alphanumeric({String message = 'Debe contener solo letras y números'}) {
    final RegExp alphanumericOnly = RegExp(r'^[a-zA-Z0-9]+$');
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || alphanumericOnly.hasMatch(value),
      errorMessage: message,
    );
  }

  /// Valida una contraseña fuerte (al menos 8 caracteres, una mayúscula, una minúscula y un número)
  static Validator strongPassword({
    String message = 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número',
  }) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\d\s]).{8,}$',
    );

    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || passwordRegex.hasMatch(value),
      errorMessage: message,
    );
  }

  /// Valida que el campo tenga un valor booleano "true"
  static Validator mustBeTrue({String message = 'Debe ser aceptado'}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value == 'true',
      errorMessage: message,
    );
  }

  /// Valida que el valor esté dentro de un rango numérico
  static Validator range(num min, num max, {String? message}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) {
        if (value.isEmpty) return true;
        final num? numValue = double.tryParse(value);
        return numValue != null && numValue >= min && numValue <= max;
      },
      errorMessage: message ?? 'Debe estar entre $min y $max',
    );
  }

  /// Valida que el texto coincida con un patrón de expresión regular personalizado
  static Validator pattern(RegExp regex, {required String message}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) => value.isEmpty || regex.hasMatch(value),
      errorMessage: message,
    );
  }

  /// Validador para valor mínimo (números)
  static Validator min(double minValue, {String? message}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) {
        if (value.isEmpty) return true;
        
        final numValue = double.tryParse(value);
        if (numValue == null) return true;
        
        if (numValue < minValue) {
          return false;
        }
        return true;
      },
      errorMessage: message ?? 'Valor mínimo: $minValue',
    );
  }

  /// Validador para valor máximo (números)
  static Validator max(double maxValue, {String? message}) {
    return Validator(
      isValid: (value, {Map<String, String>? allValues}) {
        if (value.isEmpty) return true;
        
        final numValue = double.tryParse(value);
        if (numValue == null) return true;
        
        if (numValue > maxValue) {
          return false;
        }
        return true;
      },
      errorMessage: message ?? 'Valor máximo: $maxValue',
    );
  }
}
