import '../../../core/services/api_service.dart';
import '../../../core/network/api_result.dart';
import '../model/store.dart';

class StoreRepository {
  static final StoreRepository _instance = StoreRepository._internal();
  factory StoreRepository() => _instance;
  StoreRepository._internal();

  final ApiService _apiService = ApiService();

  Map<String, dynamic> _mapStoreFields(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'name': json['name'],
      'sector': json['sector'],
      'city': json['city'],
      'location': json['location'],
      'image': json['image'],
      'description': json['description'],
      'address': json['address'],
      'phone': json['phone'],
      'email': json['email'],
      'ownerId': json['owner_id'],
      'products': json['products'] ?? [],
      'isActive': json['is_active'] ?? true,
      'createdAt': json['created_at'],
      'updatedAt': json['updated_at'],
    };
  }

  Future<ApiResult<List<Store>>> getStores({
    int page = 1,
    int limit = 10,
    String? search,
    String? city,
    String? sector,
  }) async {
    final result = await _apiService.getStores(
      page: page,
      limit: limit,
      search: search,
      city: city,
      sector: sector,
    );

    return result.when(
      success: (data) {
        final storesList = (data['stores'] as List)
            .map((storeJson) => Store.fromJson(_mapStoreFields(storeJson)))
            .toList();
        return ApiResult.success(storesList);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Store>> getStore(String id) async {
    final result = await _apiService.getStore(id);

    return result.when(
      success: (data) {
        final store = Store.fromJson(_mapStoreFields(data));
        return ApiResult.success(store);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Store>> createStore(Store store) async {
    final storeData = store.toJson();
    storeData.remove('id');
    storeData.remove('owner_id');
    storeData.remove('created_at');
    storeData.remove('updated_at');

    final result = await _apiService.createStore(storeData);

    return result.when(
      success: (data) {
        // Handle both single store response and stores array response
        Map<String, dynamic> storeData;
        if (data.containsKey('stores') && data['stores'] is List) {
          // Response has stores array (like getStores)
          final stores = data['stores'] as List;
          if (stores.isNotEmpty) {
            storeData = stores.first as Map<String, dynamic>;
          } else {
            return ApiResult.failure('No store returned from API');
          }
        } else {
          // Response is a single store object
          storeData = data;
        }

        final createdStore = Store.fromJson(_mapStoreFields(storeData));
        return ApiResult.success(createdStore);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Store>> updateStore(Store store) async {
    final storeData = store.toJson();
    storeData.remove('id');
    storeData.remove('owner_id');
    storeData.remove('created_at');
    storeData.remove('updated_at');

    final result = await _apiService.updateStore(store.id, storeData);

    return result.when(
      success: (data) {
        final updatedStore = Store.fromJson(_mapStoreFields(data));
        return ApiResult.success(updatedStore);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<String>> deleteStore(String id) async {
    final result = await _apiService.deleteStore(id);

    return result.when(
      success: (data) => ApiResult.success('تم حذف المتجر بنجاح'),
      failure: (message) => ApiResult.failure(message),
    );
  }
}
