import 'http_service.dart';

/// Factory para crear el servicio HTTP
class HttpServiceFactory {
  static HttpService create({
    String baseUrl = 'https://api.example.com',
    bool useMockData = true,
    Duration connectTimeout = const Duration(seconds: 5),
    Duration receiveTimeout = const Duration(seconds: 3),
  }) {
    return HttpService(
      baseUrl: baseUrl,
      useMockData: useMockData,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
  }
}
