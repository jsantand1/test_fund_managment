import 'dart:io';

import 'package:test_fund_managment/domain/entites/error/error_item.dart';
import 'package:test_fund_managment/domain/exceptions/base_exception.dart';

class ExceptionHelper {
  ExceptionHelper._();  

  static ErrorItem handlerBaseExceptionToErrorItem(
    dynamic exception) {
    ErrorItem errorItem;
    
    if (exception is BaseException) {
      errorItem = exception.getError();
    } else if (exception is SocketException) {
      errorItem = const ErrorItem(
        message: 'Error de conectividad',
        code: 500,
      );
    } else if (exception is FormatException) {
      errorItem = const ErrorItem(
        message: 'Error en el formato de datos',
        code: 400,
      );
    } else if (exception is Exception) {
      errorItem = ErrorItem(
        message: 'Se ha producido un error: ${exception.toString()}',
        code: 500,
      );
    } else {
      // Para cualquier otro tipo de error
      errorItem = ErrorItem(
        message: 'Error inesperado: ${exception.toString()}',
        code: 500,
      );
    }

    return errorItem;
  }
}
