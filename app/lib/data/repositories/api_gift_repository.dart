import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../models/gift_category.dart';
import '../models/gift_request.dart';
import '../models/product.dart';
import '../models/recommendation.dart';
import 'gift_repository.dart';

/// Real recommendation repository that connects to POST /api/v1/recommendations.
/// Enforces:
/// 1. Network connectivity check before dispatching request.
/// 2. User-friendly error mapping (no raw errors or stack traces).
/// 3. Strict budget safety net filtering in UI layer.
class ApiGiftRepository implements GiftRepository {
  final ApiClient _client;
  final Connectivity _connectivity;

  ApiGiftRepository({
    ApiClient? client,
    Connectivity? connectivity,
  })  : _client = client ?? ApiClient(),
        _connectivity = connectivity ?? Connectivity();

  @override
  Future<List<Recommendation>> getRecommendations(GiftRequest request) async {
    // 1. Check network connectivity BEFORE sending request
    final connectivityResults = await _connectivity.checkConnectivity();
    final hasConnection = connectivityResults.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);

    if (!hasConnection) {
      throw const ApiException(
        'Internet connection is required to generate new recommendations.',
      );
    }

    try {
      // 2. Dispatch request to real backend with contract JSON payload
      final response = await _client.post<Map<String, dynamic>>(
        '/api/v1/recommendations',
        data: request.toJson(),
      );

      final data = response.data;
      if (data == null) {
        return [];
      }

      final rawCategories = data['categories'] as List<dynamic>? ?? [];
      if (rawCategories.isEmpty) {
        return [];
      }

      final List<Recommendation> recommendations = [];

      for (int i = 0; i < rawCategories.length; i++) {
        final catMap = rawCategories[i] as Map<String, dynamic>;
        final category = GiftCategory.fromJson(catMap);

        final rawProducts = (catMap['products'] as List<dynamic>?)
                ?.map((p) => Product.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [];

        // 3. Strict budget safety net: drop any product with price > request.budget
        final affordableProducts = rawProducts
            .where((product) => product.price <= request.budget)
            .toList();

        // Only include category if it has at least one affordable product
        if (affordableProducts.isNotEmpty) {
          final updatedCategory = category.copyWith(
            productCount: affordableProducts.length,
          );

          recommendations.add(
            Recommendation(
              id: 'rec_${category.id}',
              category: updatedCategory,
              products: affordableProducts,
              rank: recommendations.length + 1,
              matchReason: category.reason,
            ),
          );
        }
      }

      // Limit to 4 categories per contract specification
      return recommendations.take(4).toList();
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (_) {
      throw const ApiException(
        'Failed to generate recommendations. Please try again.',
      );
    }
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          'The AI server took too long to respond. Please try again.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 429) {
          return const ApiException(
            'Too many requests. Please wait a moment before trying again.',
            statusCode: 429,
          );
        } else if (statusCode == 500 || statusCode == 503) {
          return ApiException(
            'Our gift recommendation service is temporarily unavailable. Please try again in a moment.',
            statusCode: statusCode,
          );
        } else if (statusCode == 413) {
          return const ApiException(
            'Request is too large. Please shorten your additional details and try again.',
            statusCode: 413,
          );
        } else if (statusCode == 422) {
          return const ApiException(
            'Unable to process these gift preferences. Please check your inputs and try again.',
            statusCode: 422,
          );
        }
        return ApiException(
          'Our gift recommendation service encountered an issue. Please try again.',
          statusCode: statusCode,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          'Unable to connect to the server. Please check your internet connection and try again.',
        );

      case DioExceptionType.cancel:
        return const ApiException('Request was cancelled.');

      default:
        return const ApiException(
          'An unexpected network error occurred. Please try again.',
        );
    }
  }
}
