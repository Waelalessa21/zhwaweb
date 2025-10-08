import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
class Store with _$Store {
  const factory Store({
    required String id,
    required String name,
    required String sector,
    required String city,
    required String location,
    required String image,
    required String description,
    required String address,
    required String phone,
    required String email,
    required String ownerId,
    @Default([]) List<String> products,
    @Default(true) bool isActive,
    String? createdAt,
    String? updatedAt,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}
