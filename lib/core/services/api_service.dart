import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../network/api_result.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _token;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {ApiConstants.contentTypeHeader: ApiConstants.applicationJson},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers[ApiConstants.authorizationHeader] =
                '${ApiConstants.bearerPrefix}$_token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _token = null;
          }
          handler.next(error);
        },
      ),
    );
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<ApiResult<T>> _handleResponse<T>(
    Future<Response> Function() request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await request();
      print('API Response: ${response.statusCode} - ${response.data}');
      final data = fromJson(response.data);
      return ApiResult.success(data);
    } on DioException catch (e) {
      print('API Error: ${e.response?.statusCode} - ${e.response?.data}');
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        return ApiResult.failure(errorData['message'] ?? 'حدث خطأ غير متوقع');
      }
      return ApiResult.failure('خطأ في الاتصال بالخادم');
    } catch (e) {
      print('Unexpected error: $e');
      return ApiResult.failure('حدث خطأ غير متوقع');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> login(
    String username,
    String password,
  ) async {
    print(
      'API Service: Attempting login to ${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}',
    );
    print('API Service: Username: $username, Password: $password');

    return _handleResponse(
      () => _dio.post(
        ApiConstants.loginEndpoint,
        data: {'username': username, 'password': password},
      ),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> logout() async {
    return _handleResponse(
      () => _dio.post(ApiConstants.logoutEndpoint),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getStores({
    int page = 1,
    int limit = 10,
    String? search,
    String? city,
    String? sector,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};

    if (search != null) queryParams['search'] = search;
    if (city != null) queryParams['city'] = city;
    if (sector != null) queryParams['sector'] = sector;

    return _handleResponse(
      () => _dio.get(ApiConstants.storesEndpoint, queryParameters: queryParams),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getStore(String id) async {
    return _handleResponse(
      () => _dio.get('${ApiConstants.storesEndpoint}/$id'),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createStore(
    Map<String, dynamic> storeData,
  ) async {
    return _handleResponse(
      () => _dio.post(ApiConstants.storesEndpoint, data: storeData),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateStore(
    String id,
    Map<String, dynamic> storeData,
  ) async {
    return _handleResponse(
      () => _dio.put('${ApiConstants.storesEndpoint}/$id', data: storeData),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> deleteStore(String id) async {
    return _handleResponse(
      () => _dio.delete('${ApiConstants.storesEndpoint}/$id'),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getOffers({
    int page = 1,
    int limit = 10,
    String? search,
    String? storeId,
    bool activeOnly = true,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      'active_only': activeOnly,
    };

    if (search != null) queryParams['search'] = search;
    if (storeId != null) queryParams['store_id'] = storeId;

    return _handleResponse(
      () => _dio.get(ApiConstants.offersEndpoint, queryParameters: queryParams),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getOffer(String id) async {
    return _handleResponse(
      () => _dio.get('${ApiConstants.offersEndpoint}/$id'),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createOffer(
    Map<String, dynamic> offerData,
  ) async {
    return _handleResponse(
      () => _dio.post(ApiConstants.offersEndpoint, data: offerData),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateOffer(
    String id,
    Map<String, dynamic> offerData,
  ) async {
    return _handleResponse(
      () => _dio.put('${ApiConstants.offersEndpoint}/$id', data: offerData),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> deleteOffer(String id) async {
    return _handleResponse(
      () => _dio.delete('${ApiConstants.offersEndpoint}/$id'),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> uploadImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        ApiConstants.uploadEndpoint,
        data: formData,
        options: Options(
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.multipartFormData,
          },
        ),
      );

      return ApiResult.success(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        return ApiResult.failure(
          errorData['message'] ?? 'حدث خطأ في رفع الصورة',
        );
      }
      return ApiResult.failure('خطأ في رفع الصورة');
    } catch (e) {
      return ApiResult.failure('حدث خطأ غير متوقع');
    }
  }

  Future<ApiResult<Map<String, dynamic>>> getDashboardStats() async {
    return _handleResponse(
      () => _dio.get(ApiConstants.dashboardEndpoint),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> createSubscription(
    Map<String, dynamic> subscriptionData,
  ) async {
    return _handleResponse(
      () => _dio.post(
        ApiConstants.subscriptionsEndpoint,
        data: subscriptionData,
        options: Options(
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
          },
        ),
      ),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getSubscriptions({
    String status = 'pending',
  }) async {
    return _handleResponse(
      () => _dio.get(
        ApiConstants.subscriptionsEndpoint,
        queryParameters: {'status': status},
      ),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> checkSubscriptionStatus(
    String email,
  ) async {
    return _handleResponse(
      () => _dio.get(
        '${ApiConstants.subscriptionsEndpoint}/check/${Uri.encodeComponent(email)}',
      ),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> updateSubscriptionByEmail(
    String email,
    Map<String, dynamic> updateData,
  ) async {
    return _handleResponse(
      () => _dio.put(
        '${ApiConstants.subscriptionsEndpoint}/update-by-email/${Uri.encodeComponent(email)}',
        data: updateData,
        options: Options(
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
          },
        ),
      ),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> approveSubscription(
    String subscriptionId,
  ) async {
    return _handleResponse(
      () => _dio.put(
        '${ApiConstants.subscriptionsEndpoint}/$subscriptionId/approve',
      ),
      (json) => json,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> rejectSubscription(
    String subscriptionId,
  ) async {
    return _handleResponse(
      () => _dio.put(
        '${ApiConstants.subscriptionsEndpoint}/$subscriptionId/reject',
      ),
      (json) => json,
    );
  }
}
