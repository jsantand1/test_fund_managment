/// Clase para manejar las validaciones de campos de texto
class Validator {
  /// Función que valida el texto y devuelve true si es válido
  /// Opcionalmente puede recibir un mapa con todos los valores del formulario
  final bool Function(String value, {Map<String, String>? allValues}) isValid;
  
  /// Mensaje de error que se mostrará si la validación falla
  final String errorMessage;
  
  /// Constructor
  Validator({required this.isValid, required this.errorMessage});
}
