import '../models/gift_request.dart';
import '../models/recommendation.dart';

abstract class GiftRepository {
  Future<List<Recommendation>> getRecommendations(GiftRequest request);
}
