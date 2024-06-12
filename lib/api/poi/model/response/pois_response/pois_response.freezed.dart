// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pois_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PoisResponse _$PoisResponseFromJson(Map<String, dynamic> json) {
  return _PoisResponse.fromJson(json);
}

/// @nodoc
mixin _$PoisResponse {
  Meta get meta => throw _privateConstructorUsedError;
  List<Poi> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PoisResponseCopyWith<PoisResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoisResponseCopyWith<$Res> {
  factory $PoisResponseCopyWith(
          PoisResponse value, $Res Function(PoisResponse) then) =
      _$PoisResponseCopyWithImpl<$Res, PoisResponse>;
  @useResult
  $Res call({Meta meta, List<Poi> data});

  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$PoisResponseCopyWithImpl<$Res, $Val extends PoisResponse>
    implements $PoisResponseCopyWith<$Res> {
  _$PoisResponseCopyWithImpl(this._value, this._then);

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
              as List<Poi>,
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
abstract class _$$PoisResponseImplCopyWith<$Res>
    implements $PoisResponseCopyWith<$Res> {
  factory _$$PoisResponseImplCopyWith(
          _$PoisResponseImpl value, $Res Function(_$PoisResponseImpl) then) =
      __$$PoisResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Meta meta, List<Poi> data});

  @override
  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$PoisResponseImplCopyWithImpl<$Res>
    extends _$PoisResponseCopyWithImpl<$Res, _$PoisResponseImpl>
    implements _$$PoisResponseImplCopyWith<$Res> {
  __$$PoisResponseImplCopyWithImpl(
      _$PoisResponseImpl _value, $Res Function(_$PoisResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? data = null,
  }) {
    return _then(_$PoisResponseImpl(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Poi>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoisResponseImpl implements _PoisResponse {
  const _$PoisResponseImpl({required this.meta, required final List<Poi> data})
      : _data = data;

  factory _$PoisResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoisResponseImplFromJson(json);

  @override
  final Meta meta;
  final List<Poi> _data;
  @override
  List<Poi> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'PoisResponse(meta: $meta, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoisResponseImpl &&
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
  _$$PoisResponseImplCopyWith<_$PoisResponseImpl> get copyWith =>
      __$$PoisResponseImplCopyWithImpl<_$PoisResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoisResponseImplToJson(
      this,
    );
  }
}

abstract class _PoisResponse implements PoisResponse {
  const factory _PoisResponse(
      {required final Meta meta,
      required final List<Poi> data}) = _$PoisResponseImpl;

  factory _PoisResponse.fromJson(Map<String, dynamic> json) =
      _$PoisResponseImpl.fromJson;

  @override
  Meta get meta;
  @override
  List<Poi> get data;
  @override
  @JsonKey(ignore: true)
  _$$PoisResponseImplCopyWith<_$PoisResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
