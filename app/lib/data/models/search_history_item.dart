import '../../core/utils/app_utils.dart';
import 'gift_request.dart';
import 'recommendation.dart';

class SearchHistoryItem {
  final String id;
  final String title;
  final String subtitle;
  final GiftRequest request;
  final List<Recommendation> recommendations;
  final DateTime createdAt;

  SearchHistoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.request,
    required this.recommendations,
    required this.createdAt,
  });

  factory SearchHistoryItem.create({
    required GiftRequest request,
    required List<Recommendation> recommendations,
    DateTime? createdAt,
    String? customId,
  }) {
    final now = createdAt ?? DateTime.now();
    return SearchHistoryItem(
      id: customId ?? 'search_${now.millisecondsSinceEpoch}',
      title: buildTitle(request),
      subtitle: buildSubtitle(request),
      request: request,
      recommendations: recommendations,
      createdAt: now,
    );
  }

  static String buildTitle(GiftRequest request) {
    if (request.occasion.trim().isNotEmpty) {
      return '${request.occasion} Gift Search';
    }
    return 'Gift Search';
  }

  static String buildSubtitle(GiftRequest request) {
    final parts = <String>[];
    if (request.relationship.trim().isNotEmpty) {
      parts.add(request.relationship.trim());
    }
    if (request.interests.isNotEmpty) {
      parts.add(request.interests.first);
    } else if (request.giftStyles.isNotEmpty) {
      parts.add(request.giftStyles.first);
    }
    parts.add(AppUtils.formatPkr(request.budget.toInt()));
    return parts.join(' · ');
  }

  String get formattedDate {
    final now = DateTime.now();
    final isToday = now.year == createdAt.year &&
        now.month == createdAt.month &&
        now.day == createdAt.day;

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == createdAt.year &&
        yesterday.month == createdAt.month &&
        yesterday.day == createdAt.day;

    final hour = createdAt.hour == 0
        ? 12
        : (createdAt.hour > 12 ? createdAt.hour - 12 : createdAt.hour);
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final ampm = createdAt.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $ampm';

    if (isToday) {
      final diff = now.difference(createdAt);
      if (diff.inMinutes < 2) {
        return 'Just now';
      }
      return 'Today, $timeStr';
    } else if (isYesterday) {
      return 'Yesterday, $timeStr';
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final monthStr = months[createdAt.month - 1];
      return '$monthStr ${createdAt.day}, ${createdAt.year}';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'request': request.toJson(),
      'recommendations': recommendations.map((r) => r.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      request: GiftRequest.fromJson(json['request'] as Map<String, dynamic>),
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
