import '../../../core/services/api_service.dart';
import '../../../core/network/api_result.dart';
import '../model/subscription.dart';

class SubscriptionRepository {
  static final SubscriptionRepository _instance =
      SubscriptionRepository._internal();
  factory SubscriptionRepository() => _instance;
  SubscriptionRepository._internal();

  final ApiService _apiService = ApiService();

  Map<String, dynamic> _mapSubscriptionFields(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'name': json['name'],
      'sector': json['sector'],
      'city': json['city'],
      'location': json['location'],
      'address': json['address'],
      'phone': json['phone'],
      'email': json['email'],
      'products': json['products'] ?? [],
      'status': json['status'] ?? 'pending',
      'image': json['image'],
      'description': json['description'],
      'createdAt': json['created_at'],
      'updatedAt': json['updated_at'],
    };
  }

  Future<ApiResult<List<Subscription>>> getSubscriptions({
    String status = 'pending',
  }) async {
    final result = await _apiService.getSubscriptions(status: status);

    return result.when(
      success: (data) {
        final subscriptionsList = (data['subscriptions'] as List)
            .map(
              (subscriptionJson) => Subscription.fromJson(
                _mapSubscriptionFields(subscriptionJson),
              ),
            )
            .toList();
        return ApiResult.success(subscriptionsList);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Subscription>> createSubscription(
    Subscription subscription,
  ) async {
    final subscriptionData = subscription.toJson();
    subscriptionData.remove('id');
    subscriptionData.remove('status');
    subscriptionData.remove('created_at');
    subscriptionData.remove('updated_at');

    final result = await _apiService.createSubscription(subscriptionData);

    return result.when(
      success: (data) {
        final createdSubscription = Subscription.fromJson(
          _mapSubscriptionFields(data),
        );
        return ApiResult.success(createdSubscription);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Subscription>> checkSubscriptionStatus(String email) async {
    final result = await _apiService.checkSubscriptionStatus(email);

    return result.when(
      success: (data) {
        final subscription = Subscription.fromJson(
          _mapSubscriptionFields(data),
        );
        return ApiResult.success(subscription);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Subscription>> updateSubscriptionByEmail(
    String email,
    Subscription subscription,
  ) async {
    final subscriptionData = subscription.toJson();
    subscriptionData.remove('id');
    subscriptionData.remove('status');
    subscriptionData.remove('created_at');
    subscriptionData.remove('updated_at');

    final result = await _apiService.updateSubscriptionByEmail(
      email,
      subscriptionData,
    );

    return result.when(
      success: (data) {
        final updatedSubscription = Subscription.fromJson(
          _mapSubscriptionFields(data),
        );
        return ApiResult.success(updatedSubscription);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Subscription>> approveSubscription(
    String subscriptionId,
  ) async {
    final result = await _apiService.approveSubscription(subscriptionId);

    return result.when(
      success: (data) {
        final approvedSubscription = Subscription.fromJson(
          _mapSubscriptionFields(data),
        );
        return ApiResult.success(approvedSubscription);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }

  Future<ApiResult<Subscription>> rejectSubscription(
    String subscriptionId,
  ) async {
    final result = await _apiService.rejectSubscription(subscriptionId);

    return result.when(
      success: (data) {
        final rejectedSubscription = Subscription.fromJson(
          _mapSubscriptionFields(data),
        );
        return ApiResult.success(rejectedSubscription);
      },
      failure: (message) => ApiResult.failure(message),
    );
  }
}
