import 'package:test_fund_managment/domain/entites/error/error_item.dart';

abstract class BaseException implements Exception {
  late ErrorItem _errorItem;

  BaseException(ErrorItem errorItem) {
    _errorItem = errorItem;
  }

  ErrorItem getError() => _errorItem;

  @override
  String toString() {

    String messageStr = 'message: ${_errorItem.message}';
    return messageStr;
  }
}