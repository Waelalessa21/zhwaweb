// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  discountPercentage: (json['discountPercentage'] as num).toInt(),
  image: json['image'] as String,
  validUntil: DateTime.parse(json['validUntil'] as String),
  storeId: json['storeId'] as String,
  storeName: json['storeName'] as String,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'discountPercentage': instance.discountPercentage,
      'image': instance.image,
      'validUntil': instance.validUntil.toIso8601String(),
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
