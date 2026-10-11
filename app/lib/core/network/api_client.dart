import 'package:dio/dio.dart';
import '../config/app_config.dart';

/// Network client powered by Dio.
/// Uses configurable base URL and 60-second timeouts to accommodate free-tier cold starts.
/// Strictly contains NO API secrets.
class ApiClient {
  late final Dio dio;

  ApiClient({Dio? customDio}) {
    if (customDio != null) {
      dio = customDio;
    } else {
      final options = BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.timeoutDuration,
        receiveTimeout: AppConfig.timeoutDuration,
        sendTimeout: AppConfig.timeoutDuration,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      dio = Dio(options);

      // Interceptor to synchronize base URL dynamically if changed via AppConfig
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (!options.path.startsWith('http://') && !options.path.startsWith('https://')) {
              options.baseUrl = AppConfig.baseUrl;
            }
            return handler.next(options);
          },
        ),
      );
    }
  }

  /// Sends a POST request with JSON body
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Sends a GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
