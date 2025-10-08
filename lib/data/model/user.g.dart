// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  username: json['username'] as String,
  password: json['password'] as String,
  type: UserType.fromJson(json['type'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'type': instance.type,
    };

_$AdminImpl _$$AdminImplFromJson(Map<String, dynamic> json) =>
    _$AdminImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$AdminImplToJson(_$AdminImpl instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

_$StoreImpl _$$StoreImplFromJson(Map<String, dynamic> json) =>
    _$StoreImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$StoreImplToJson(_$StoreImpl instance) =>
    <String, dynamic>{'runtimeType': instance.$type};
