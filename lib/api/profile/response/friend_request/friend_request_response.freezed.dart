// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_request_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetFriendRequestResponse _$GetFriendRequestResponseFromJson(
    Map<String, dynamic> json) {
  return _GetFriendsPaginationResponse.fromJson(json);
}

/// @nodoc
mixin _$GetFriendRequestResponse {
  Meta get meta => throw _privateConstructorUsedError;
  List<FriendRequest> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetFriendRequestResponseCopyWith<GetFriendRequestResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetFriendRequestResponseCopyWith<$Res> {
  factory $GetFriendRequestResponseCopyWith(GetFriendRequestResponse value,
          $Res Function(GetFriendRequestResponse) then) =
      _$GetFriendRequestResponseCopyWithImpl<$Res, GetFriendRequestResponse>;
  @useResult
  $Res call({Meta meta, List<FriendRequest> data});

  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$GetFriendRequestResponseCopyWithImpl<$Res,
        $Val extends GetFriendRequestResponse>
    implements $GetFriendRequestResponseCopyWith<$Res> {
  _$GetFriendRequestResponseCopyWithImpl(this._value, this._then);

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
              as List<FriendRequest>,
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
abstract class _$$GetFriendsPaginationResponseImplCopyWith<$Res>
    implements $GetFriendRequestResponseCopyWith<$Res> {
  factory _$$GetFriendsPaginationResponseImplCopyWith(
          _$GetFriendsPaginationResponseImpl value,
          $Res Function(_$GetFriendsPaginationResponseImpl) then) =
      __$$GetFriendsPaginationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Meta meta, List<FriendRequest> data});

  @override
  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$GetFriendsPaginationResponseImplCopyWithImpl<$Res>
    extends _$GetFriendRequestResponseCopyWithImpl<$Res,
        _$GetFriendsPaginationResponseImpl>
    implements _$$GetFriendsPaginationResponseImplCopyWith<$Res> {
  __$$GetFriendsPaginationResponseImplCopyWithImpl(
      _$GetFriendsPaginationResponseImpl _value,
      $Res Function(_$GetFriendsPaginationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? data = null,
  }) {
    return _then(_$GetFriendsPaginationResponseImpl(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<FriendRequest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetFriendsPaginationResponseImpl
    implements _GetFriendsPaginationResponse {
  const _$GetFriendsPaginationResponseImpl(
      {required this.meta, required final List<FriendRequest> data})
      : _data = data;

  factory _$GetFriendsPaginationResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetFriendsPaginationResponseImplFromJson(json);

  @override
  final Meta meta;
  final List<FriendRequest> _data;
  @override
  List<FriendRequest> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'GetFriendRequestResponse(meta: $meta, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetFriendsPaginationResponseImpl &&
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
  _$$GetFriendsPaginationResponseImplCopyWith<
          _$GetFriendsPaginationResponseImpl>
      get copyWith => __$$GetFriendsPaginationResponseImplCopyWithImpl<
          _$GetFriendsPaginationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetFriendsPaginationResponseImplToJson(
      this,
    );
  }
}

abstract class _GetFriendsPaginationResponse
    implements GetFriendRequestResponse {
  const factory _GetFriendsPaginationResponse(
          {required final Meta meta, required final List<FriendRequest> data}) =
      _$GetFriendsPaginationResponseImpl;

  factory _GetFriendsPaginationResponse.fromJson(Map<String, dynamic> json) =
      _$GetFriendsPaginationResponseImpl.fromJson;

  @override
  Meta get meta;
  @override
  List<FriendRequest> get data;
  @override
  @JsonKey(ignore: true)
  _$$GetFriendsPaginationResponseImplCopyWith<
          _$GetFriendsPaginationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
