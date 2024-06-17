// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_all_posts_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetAllPostsResponse _$GetAllPostsResponseFromJson(Map<String, dynamic> json) {
  return _GetAllPostsResponse.fromJson(json);
}

/// @nodoc
mixin _$GetAllPostsResponse {
  Meta get meta => throw _privateConstructorUsedError;
  List<Post> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetAllPostsResponseCopyWith<GetAllPostsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetAllPostsResponseCopyWith<$Res> {
  factory $GetAllPostsResponseCopyWith(
          GetAllPostsResponse value, $Res Function(GetAllPostsResponse) then) =
      _$GetAllPostsResponseCopyWithImpl<$Res, GetAllPostsResponse>;
  @useResult
  $Res call({Meta meta, List<Post> data});

  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$GetAllPostsResponseCopyWithImpl<$Res, $Val extends GetAllPostsResponse>
    implements $GetAllPostsResponseCopyWith<$Res> {
  _$GetAllPostsResponseCopyWithImpl(this._value, this._then);

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
              as List<Post>,
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
abstract class _$$GetAllPostsResponseImplCopyWith<$Res>
    implements $GetAllPostsResponseCopyWith<$Res> {
  factory _$$GetAllPostsResponseImplCopyWith(_$GetAllPostsResponseImpl value,
          $Res Function(_$GetAllPostsResponseImpl) then) =
      __$$GetAllPostsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Meta meta, List<Post> data});

  @override
  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$GetAllPostsResponseImplCopyWithImpl<$Res>
    extends _$GetAllPostsResponseCopyWithImpl<$Res, _$GetAllPostsResponseImpl>
    implements _$$GetAllPostsResponseImplCopyWith<$Res> {
  __$$GetAllPostsResponseImplCopyWithImpl(_$GetAllPostsResponseImpl _value,
      $Res Function(_$GetAllPostsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? data = null,
  }) {
    return _then(_$GetAllPostsResponseImpl(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Post>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetAllPostsResponseImpl implements _GetAllPostsResponse {
  const _$GetAllPostsResponseImpl(
      {required this.meta, required final List<Post> data})
      : _data = data;

  factory _$GetAllPostsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GetAllPostsResponseImplFromJson(json);

  @override
  final Meta meta;
  final List<Post> _data;
  @override
  List<Post> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'GetAllPostsResponse(meta: $meta, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetAllPostsResponseImpl &&
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
  _$$GetAllPostsResponseImplCopyWith<_$GetAllPostsResponseImpl> get copyWith =>
      __$$GetAllPostsResponseImplCopyWithImpl<_$GetAllPostsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetAllPostsResponseImplToJson(
      this,
    );
  }
}

abstract class _GetAllPostsResponse implements GetAllPostsResponse {
  const factory _GetAllPostsResponse(
      {required final Meta meta,
      required final List<Post> data}) = _$GetAllPostsResponseImpl;

  factory _GetAllPostsResponse.fromJson(Map<String, dynamic> json) =
      _$GetAllPostsResponseImpl.fromJson;

  @override
  Meta get meta;
  @override
  List<Post> get data;
  @override
  @JsonKey(ignore: true)
  _$$GetAllPostsResponseImplCopyWith<_$GetAllPostsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
