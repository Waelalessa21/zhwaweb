import '../../../core/services/api_service.dart';
import '../../../core/network/api_result.dart';
import '../model/offer.dart';

class OfferRepository {
  static final OfferRepository _instance = OfferRepository._internal();
  factory OfferRepository() => _instance;
  OfferRepository._internal();

  final ApiService _apiService = ApiService();

  Future<ApiResult<List<Offer>>> getOffers({
    int page = 1,
    int limit = 10,
    String? search,
    String? storeId,
    bool activeOnly = true,
  }) async {
    final result = await _apiService.getOffers(
      page: page,
      limit: limit,
      search: search,
      storeId: storeId,
      activeOnly: activeOnly,
    );

    return result.when(
      success: (data) {
        final offersList = (data['offers'] as List)
            .map((offerJson) => Offer.fromJson(offerJson))
            .toList();
        return ApiResult.success(offersList);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Offer>> getOffer(String id) async {
    final result = await _apiService.getOffer(id);

    return result.when(
      success: (data) {
        final offer = Offer.fromJson(data);
        return ApiResult.success(offer);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Offer>> createOffer(Offer offer) async {
    final offerData = offer.toJson();
    offerData.remove('id');
    offerData.remove('store_name');
    offerData.remove('is_active');
    offerData.remove('created_at');
    offerData.remove('updated_at');

    final result = await _apiService.createOffer(offerData);

    return result.when(
      success: (data) {
        final createdOffer = Offer.fromJson(data);
        return ApiResult.success(createdOffer);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Offer>> updateOffer(Offer offer) async {
    final offerData = offer.toJson();
    offerData.remove('id');
    offerData.remove('store_name');
    offerData.remove('is_active');
    offerData.remove('created_at');
    offerData.remove('updated_at');

    final result = await _apiService.updateOffer(offer.id, offerData);

    return result.when(
      success: (data) {
        final updatedOffer = Offer.fromJson(data);
        return ApiResult.success(updatedOffer);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<String>> deleteOffer(String id) async {
    final result = await _apiService.deleteOffer(id);

    return result.when(
      success: (data) => ApiResult.success('تم حذف العرض بنجاح'),
      failure: (message) => ApiResult.failure(message),
    );
  }
}
