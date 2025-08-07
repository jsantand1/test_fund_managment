import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:test_fund_managment/domain/entites/error/error_item.dart';
import 'package:test_fund_managment/domain/exceptions/server_exception.dart';
import 'mock_interceptor.dart';

/// Servicio HTTP simple con GET y POST usando Dio
class HttpService {
  final Dio _dio;

  HttpService({
    String baseUrl = 'https://api.example.com',
    bool useMockData = true,
    Duration connectTimeout = const Duration(seconds: 5),
    Duration receiveTimeout = const Duration(seconds: 3),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       ) {
    // Si usamos mock data, agregamos el interceptor
    if (useMockData) {
      _dio.interceptors.add(MockInterceptor());
    }
  }

  /// Realiza una petición GET
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Realiza una petición POST
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Maneja las respuestas HTTP exitosas
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is String) {
        return json.decode(response.data);
      } else {
        return {'data': response.data, 'statusCode': response.statusCode};
      }
    } else {
      throw ErrorItem(message: 'HTTP Error: ${response.statusCode}');
    }
  }

  /// Maneja los errores HTTP
  ServerException _handleError(dynamic error) {
    String generalError = "";
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          generalError = 'Connection timeout';
          break;
        case DioExceptionType.sendTimeout:
          generalError = 'Send timeout';
          break;
        case DioExceptionType.receiveTimeout:
          generalError = 'Receive timeout';
          break;
        case DioExceptionType.badResponse:
          generalError = 'Bad response: ${error.response?.statusCode}';
          break;
        case DioExceptionType.cancel:
          generalError = 'Request cancelled';
          break;
        case DioExceptionType.connectionError:
          generalError = 'Connection error';
          break;
        case DioExceptionType.unknown:
          generalError = 'Unknown error: ${error.message}';
          break;
        default:
          generalError = 'Network error: ${error.message}';
      }
    }
    return ServerException(ErrorItem(message: generalError));
  }
}
