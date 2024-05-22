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

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) {
  return _FriendRequest.fromJson(json);
}

/// @nodoc
mixin _$FriendRequest {
  int get id => throw _privateConstructorUsedError;
  int get senderId => throw _privateConstructorUsedError;
  int get receiverId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  Profile get sender => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FriendRequestCopyWith<FriendRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendRequestCopyWith<$Res> {
  factory $FriendRequestCopyWith(
          FriendRequest value, $Res Function(FriendRequest) then) =
      _$FriendRequestCopyWithImpl<$Res, FriendRequest>;
  @useResult
  $Res call(
      {int id,
      int senderId,
      int receiverId,
      DateTime createdAt,
      DateTime updatedAt,
      Profile sender});

  $ProfileCopyWith<$Res> get sender;
}

/// @nodoc
class _$FriendRequestCopyWithImpl<$Res, $Val extends FriendRequest>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sender = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as Profile,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get sender {
    return $ProfileCopyWith<$Res>(_value.sender, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendRequestImplCopyWith<$Res>
    implements $FriendRequestCopyWith<$Res> {
  factory _$$FriendRequestImplCopyWith(
          _$FriendRequestImpl value, $Res Function(_$FriendRequestImpl) then) =
      __$$FriendRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int senderId,
      int receiverId,
      DateTime createdAt,
      DateTime updatedAt,
      Profile sender});

  @override
  $ProfileCopyWith<$Res> get sender;
}

/// @nodoc
class __$$FriendRequestImplCopyWithImpl<$Res>
    extends _$FriendRequestCopyWithImpl<$Res, _$FriendRequestImpl>
    implements _$$FriendRequestImplCopyWith<$Res> {
  __$$FriendRequestImplCopyWithImpl(
      _$FriendRequestImpl _value, $Res Function(_$FriendRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sender = null,
  }) {
    return _then(_$FriendRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as Profile,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendRequestImpl implements _FriendRequest {
  const _$FriendRequestImpl(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      required this.createdAt,
      required this.updatedAt,
      required this.sender});

  factory _$FriendRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendRequestImplFromJson(json);

  @override
  final int id;
  @override
  final int senderId;
  @override
  final int receiverId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final Profile sender;

  @override
  String toString() {
    return 'FriendRequest(id: $id, senderId: $senderId, receiverId: $receiverId, createdAt: $createdAt, updatedAt: $updatedAt, sender: $sender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.sender, sender) || other.sender == sender));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, senderId, receiverId, createdAt, updatedAt, sender);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      __$$FriendRequestImplCopyWithImpl<_$FriendRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendRequestImplToJson(
      this,
    );
  }
}

abstract class _FriendRequest implements FriendRequest {
  const factory _FriendRequest(
      {required final int id,
      required final int senderId,
      required final int receiverId,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final Profile sender}) = _$FriendRequestImpl;

  factory _FriendRequest.fromJson(Map<String, dynamic> json) =
      _$FriendRequestImpl.fromJson;

  @override
  int get id;
  @override
  int get senderId;
  @override
  int get receiverId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  Profile get sender;
  @override
  @JsonKey(ignore: true)
  _$$FriendRequestImplCopyWith<_$FriendRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
