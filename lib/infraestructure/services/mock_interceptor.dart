import 'package:dio/dio.dart';

/// Interceptor para mockear respuestas de Dio
class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Simular delay de red
    Future.delayed(const Duration(milliseconds: 500), () {
      final mockResponse = _generateMockResponse(options);
      handler.resolve(mockResponse);
    });
  }

  Response _generateMockResponse(RequestOptions options) {
    final endpoint = options.path.toLowerCase();
    final method = options.method.toUpperCase();

    Map<String, dynamic> responseData;

    if (method == 'GET') {
      responseData = _getMockGetData(endpoint, options.queryParameters);
    } else {
      responseData = {
        'success': true,
        'message': 'Mock response for $method $endpoint',
        'data': {'timestamp': DateTime.now().toIso8601String()},
      };
    }

    return Response(
      requestOptions: options,
      data: responseData,
      statusCode: 200,
      headers: Headers.fromMap({
        'content-type': ['application/json'],
      }),
    );
  }

  Map<String, dynamic> _getMockGetData(
    String endpoint,
    Map<String, dynamic> queryParams,
  ) {
    switch (endpoint) {
      case '/funds':
        return {
          'success': true,
          'data': [
            {
              'id': 1,
              'name': 'FPV_BTG_PACTUAL_RECAUDADORA',
              'description': 'description',
              'minimumAmount': 75000,
              'category': 'FPV',
              'currency': 'COP',
              'risk_level': 'High',
              'created_at': '2024-01-01T00:00:00Z',
            },
            {
              'id': 2,
              'name': 'FPV_BTG_PACTUAL_ECOPETROL',
              'description': 'description',
              'minimumAmount': 125000,
              'category': 'FPV',
              'currency': 'COP',
              'risk_level': 'Low',
              'created_at': '2024-01-02T00:00:00Z',
            },
            {
              'id': 3,
              'name': 'DEUDAPRIVADA',
              'description': 'description',
              'minimumAmount': 50000,
              'category': 'FIC',
              'currency': 'COP',
              'risk_level': 'Low',
              'created_at': '2024-01-02T00:00:00Z',
            },
            {
              'id': 4,
              'name': 'FDO-ACCIONES',
              'description': 'description',
              'minimumAmount': 250000,
              'category': 'FIC',
              'currency': 'COP',
              'risk_level': 'Low',
              'created_at': '2024-01-02T00:00:00Z',
            },

            {
              'id': 5,
              'name': 'FPV_BTG_PACTUAL_DINAMICA',
              'description': 'description',
              'minimumAmount': 100000,
              'category': 'FPV',
              'currency': 'COP',
              'risk_level': 'Low',
              'created_at': '2024-01-02T00:00:00Z',
            },
          ],
          'total': 2,
        };
      default:
        return {
          'success': true,
          'message': 'Mock GET response for: $endpoint',
          'data': {
            'endpoint': endpoint,
            'queryParams': queryParams,
            'timestamp': DateTime.now().toIso8601String(),
          },
        };
    }
  }
}
