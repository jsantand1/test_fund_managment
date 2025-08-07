
/// Represents an error item with message, code, and type information.
class ErrorItem {
  /// The error message.
  final String message;
  
  /// The error code, typically an HTTP status code.
  final int? code;
  
  /// Creates a new [ErrorItem] with the given details.
  const ErrorItem({
    required this.message,
    this.code,
  });


}
