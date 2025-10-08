import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String name,
    required String sector,
    required String city,
    required String location,
    required String address,
    required String phone,
    required String email,
    @Default([]) List<String> products,
    @Default('pending') String status,
    String? image,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
