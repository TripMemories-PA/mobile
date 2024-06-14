// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Poi _$PoiFromJson(Map<String, dynamic> json) {
  return _Poi.fromJson(json);
}

/// @nodoc
mixin _$Poi {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get coverId => throw _privateConstructorUsedError;
  int? get typeId => throw _privateConstructorUsedError;
  String get latitude => throw _privateConstructorUsedError;
  String get longitude => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get zipCode => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  UploadFile get cover => throw _privateConstructorUsedError;
  Type get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PoiCopyWith<Poi> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoiCopyWith<$Res> {
  factory $PoiCopyWith(Poi value, $Res Function(Poi) then) =
      _$PoiCopyWithImpl<$Res, Poi>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      int? coverId,
      int? typeId,
      String latitude,
      String longitude,
      String? city,
      String? zipCode,
      String? address,
      DateTime createdAt,
      DateTime updatedAt,
      UploadFile cover,
      Type type});

  $UploadFileCopyWith<$Res> get cover;
  $TypeCopyWith<$Res> get type;
}

/// @nodoc
class _$PoiCopyWithImpl<$Res, $Val extends Poi> implements $PoiCopyWith<$Res> {
  _$PoiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? coverId = freezed,
    Object? typeId = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? city = freezed,
    Object? zipCode = freezed,
    Object? address = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cover = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverId: freezed == coverId
          ? _value.coverId
          : coverId // ignore: cast_nullable_to_non_nullable
              as int?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cover: null == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as UploadFile,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UploadFileCopyWith<$Res> get cover {
    return $UploadFileCopyWith<$Res>(_value.cover, (value) {
      return _then(_value.copyWith(cover: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TypeCopyWith<$Res> get type {
    return $TypeCopyWith<$Res>(_value.type, (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PoiImplCopyWith<$Res> implements $PoiCopyWith<$Res> {
  factory _$$PoiImplCopyWith(_$PoiImpl value, $Res Function(_$PoiImpl) then) =
      __$$PoiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      int? coverId,
      int? typeId,
      String latitude,
      String longitude,
      String? city,
      String? zipCode,
      String? address,
      DateTime createdAt,
      DateTime updatedAt,
      UploadFile cover,
      Type type});

  @override
  $UploadFileCopyWith<$Res> get cover;
  @override
  $TypeCopyWith<$Res> get type;
}

/// @nodoc
class __$$PoiImplCopyWithImpl<$Res> extends _$PoiCopyWithImpl<$Res, _$PoiImpl>
    implements _$$PoiImplCopyWith<$Res> {
  __$$PoiImplCopyWithImpl(_$PoiImpl _value, $Res Function(_$PoiImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? coverId = freezed,
    Object? typeId = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? city = freezed,
    Object? zipCode = freezed,
    Object? address = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? cover = null,
    Object? type = null,
  }) {
    return _then(_$PoiImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      coverId: freezed == coverId
          ? _value.coverId
          : coverId // ignore: cast_nullable_to_non_nullable
              as int?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as String,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cover: null == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as UploadFile,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoiImpl implements _Poi {
  const _$PoiImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.coverId,
      required this.typeId,
      required this.latitude,
      required this.longitude,
      required this.city,
      required this.zipCode,
      required this.address,
      required this.createdAt,
      required this.updatedAt,
      required this.cover,
      required this.type});

  factory _$PoiImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoiImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final int? coverId;
  @override
  final int? typeId;
  @override
  final String latitude;
  @override
  final String longitude;
  @override
  final String? city;
  @override
  final String? zipCode;
  @override
  final String? address;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final UploadFile cover;
  @override
  final Type type;

  @override
  String toString() {
    return 'Poi(id: $id, name: $name, description: $description, coverId: $coverId, typeId: $typeId, latitude: $latitude, longitude: $longitude, city: $city, zipCode: $zipCode, address: $address, createdAt: $createdAt, updatedAt: $updatedAt, cover: $cover, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoiImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.coverId, coverId) || other.coverId == coverId) &&
            (identical(other.typeId, typeId) || other.typeId == typeId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      coverId,
      typeId,
      latitude,
      longitude,
      city,
      zipCode,
      address,
      createdAt,
      updatedAt,
      cover,
      type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PoiImplCopyWith<_$PoiImpl> get copyWith =>
      __$$PoiImplCopyWithImpl<_$PoiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoiImplToJson(
      this,
    );
  }
}

abstract class _Poi implements Poi {
  const factory _Poi(
      {required final int id,
      required final String name,
      required final String? description,
      required final int? coverId,
      required final int? typeId,
      required final String latitude,
      required final String longitude,
      required final String? city,
      required final String? zipCode,
      required final String? address,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final UploadFile cover,
      required final Type type}) = _$PoiImpl;

  factory _Poi.fromJson(Map<String, dynamic> json) = _$PoiImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  int? get coverId;
  @override
  int? get typeId;
  @override
  String get latitude;
  @override
  String get longitude;
  @override
  String? get city;
  @override
  String? get zipCode;
  @override
  String? get address;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  UploadFile get cover;
  @override
  Type get type;
  @override
  @JsonKey(ignore: true)
  _$$PoiImplCopyWith<_$PoiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Type _$TypeFromJson(Map<String, dynamic> json) {
  return _Type.fromJson(json);
}

/// @nodoc
mixin _$Type {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TypeCopyWith<Type> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypeCopyWith<$Res> {
  factory $TypeCopyWith(Type value, $Res Function(Type) then) =
      _$TypeCopyWithImpl<$Res, Type>;
  @useResult
  $Res call({int id, String name, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$TypeCopyWithImpl<$Res, $Val extends Type>
    implements $TypeCopyWith<$Res> {
  _$TypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypeImplCopyWith<$Res> implements $TypeCopyWith<$Res> {
  factory _$$TypeImplCopyWith(
          _$TypeImpl value, $Res Function(_$TypeImpl) then) =
      __$$TypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$$TypeImplCopyWithImpl<$Res>
    extends _$TypeCopyWithImpl<$Res, _$TypeImpl>
    implements _$$TypeImplCopyWith<$Res> {
  __$$TypeImplCopyWithImpl(_$TypeImpl _value, $Res Function(_$TypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$TypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypeImpl implements _Type {
  const _$TypeImpl(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});

  factory _$TypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypeImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Type(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TypeImplCopyWith<_$TypeImpl> get copyWith =>
      __$$TypeImplCopyWithImpl<_$TypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypeImplToJson(
      this,
    );
  }
}

abstract class _Type implements Type {
  const factory _Type(
      {required final int id,
      required final String name,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$TypeImpl;

  factory _Type.fromJson(Map<String, dynamic> json) = _$TypeImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TypeImplCopyWith<_$TypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
