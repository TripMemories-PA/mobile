// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cities_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CitiesResponse _$CitiesResponseFromJson(Map<String, dynamic> json) {
  return _CitiesResponse.fromJson(json);
}

/// @nodoc
mixin _$CitiesResponse {
  Meta get meta => throw _privateConstructorUsedError;
  List<City> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CitiesResponseCopyWith<CitiesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CitiesResponseCopyWith<$Res> {
  factory $CitiesResponseCopyWith(
          CitiesResponse value, $Res Function(CitiesResponse) then) =
      _$CitiesResponseCopyWithImpl<$Res, CitiesResponse>;
  @useResult
  $Res call({Meta meta, List<City> data});

  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$CitiesResponseCopyWithImpl<$Res, $Val extends CitiesResponse>
    implements $CitiesResponseCopyWith<$Res> {
  _$CitiesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<City>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MetaCopyWith<$Res> get meta {
    return $MetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CitiesResponseImplCopyWith<$Res>
    implements $CitiesResponseCopyWith<$Res> {
  factory _$$CitiesResponseImplCopyWith(_$CitiesResponseImpl value,
          $Res Function(_$CitiesResponseImpl) then) =
      __$$CitiesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Meta meta, List<City> data});

  @override
  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$CitiesResponseImplCopyWithImpl<$Res>
    extends _$CitiesResponseCopyWithImpl<$Res, _$CitiesResponseImpl>
    implements _$$CitiesResponseImplCopyWith<$Res> {
  __$$CitiesResponseImplCopyWithImpl(
      _$CitiesResponseImpl _value, $Res Function(_$CitiesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? data = null,
  }) {
    return _then(_$CitiesResponseImpl(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<City>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CitiesResponseImpl implements _CitiesResponse {
  const _$CitiesResponseImpl(
      {required this.meta, required final List<City> data})
      : _data = data;

  factory _$CitiesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CitiesResponseImplFromJson(json);

  @override
  final Meta meta;
  final List<City> _data;
  @override
  List<City> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'CitiesResponse(meta: $meta, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CitiesResponseImpl &&
            (identical(other.meta, meta) || other.meta == meta) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, meta, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CitiesResponseImplCopyWith<_$CitiesResponseImpl> get copyWith =>
      __$$CitiesResponseImplCopyWithImpl<_$CitiesResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CitiesResponseImplToJson(
      this,
    );
  }
}

abstract class _CitiesResponse implements CitiesResponse {
  const factory _CitiesResponse(
      {required final Meta meta,
      required final List<City> data}) = _$CitiesResponseImpl;

  factory _CitiesResponse.fromJson(Map<String, dynamic> json) =
      _$CitiesResponseImpl.fromJson;

  @override
  Meta get meta;
  @override
  List<City> get data;
  @override
  @JsonKey(ignore: true)
  _$$CitiesResponseImplCopyWith<_$CitiesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
