// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'who_am_i_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WhoAmIResponse _$WhoAmIResponseFromJson(Map<String, dynamic> json) {
  return _WhoAmIResponse.fromJson(json);
}

/// @nodoc
mixin _$WhoAmIResponse {
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  UploadFile? get avatar => throw _privateConstructorUsedError;
  UploadFile? get banner => throw _privateConstructorUsedError;
  List<FriendRequest>? get sentFriendRequests =>
      throw _privateConstructorUsedError;
  List<FriendRequest>? get receivedFriendRequests =>
      throw _privateConstructorUsedError;
  List<dynamic>? get friends => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WhoAmIResponseCopyWith<WhoAmIResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WhoAmIResponseCopyWith<$Res> {
  factory $WhoAmIResponseCopyWith(
          WhoAmIResponse value, $Res Function(WhoAmIResponse) then) =
      _$WhoAmIResponseCopyWithImpl<$Res, WhoAmIResponse>;
  @useResult
  $Res call(
      {int id,
      String email,
      String username,
      String? firstname,
      String? lastname,
      String createdAt,
      String updatedAt,
      UploadFile? avatar,
      UploadFile? banner,
      List<FriendRequest>? sentFriendRequests,
      List<FriendRequest>? receivedFriendRequests,
      List<dynamic>? friends});

  $UploadFileCopyWith<$Res>? get avatar;
  $UploadFileCopyWith<$Res>? get banner;
}

/// @nodoc
class _$WhoAmIResponseCopyWithImpl<$Res, $Val extends WhoAmIResponse>
    implements $WhoAmIResponseCopyWith<$Res> {
  _$WhoAmIResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? avatar = freezed,
    Object? banner = freezed,
    Object? sentFriendRequests = freezed,
    Object? receivedFriendRequests = freezed,
    Object? friends = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      firstname: freezed == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String?,
      lastname: freezed == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      sentFriendRequests: freezed == sentFriendRequests
          ? _value.sentFriendRequests
          : sentFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<FriendRequest>?,
      receivedFriendRequests: freezed == receivedFriendRequests
          ? _value.receivedFriendRequests
          : receivedFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<FriendRequest>?,
      friends: freezed == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UploadFileCopyWith<$Res>? get avatar {
    if (_value.avatar == null) {
      return null;
    }

    return $UploadFileCopyWith<$Res>(_value.avatar!, (value) {
      return _then(_value.copyWith(avatar: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UploadFileCopyWith<$Res>? get banner {
    if (_value.banner == null) {
      return null;
    }

    return $UploadFileCopyWith<$Res>(_value.banner!, (value) {
      return _then(_value.copyWith(banner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WhoAmIResponseImplCopyWith<$Res>
    implements $WhoAmIResponseCopyWith<$Res> {
  factory _$$WhoAmIResponseImplCopyWith(_$WhoAmIResponseImpl value,
          $Res Function(_$WhoAmIResponseImpl) then) =
      __$$WhoAmIResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String email,
      String username,
      String? firstname,
      String? lastname,
      String createdAt,
      String updatedAt,
      UploadFile? avatar,
      UploadFile? banner,
      List<FriendRequest>? sentFriendRequests,
      List<FriendRequest>? receivedFriendRequests,
      List<dynamic>? friends});

  @override
  $UploadFileCopyWith<$Res>? get avatar;
  @override
  $UploadFileCopyWith<$Res>? get banner;
}

/// @nodoc
class __$$WhoAmIResponseImplCopyWithImpl<$Res>
    extends _$WhoAmIResponseCopyWithImpl<$Res, _$WhoAmIResponseImpl>
    implements _$$WhoAmIResponseImplCopyWith<$Res> {
  __$$WhoAmIResponseImplCopyWithImpl(
      _$WhoAmIResponseImpl _value, $Res Function(_$WhoAmIResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? avatar = freezed,
    Object? banner = freezed,
    Object? sentFriendRequests = freezed,
    Object? receivedFriendRequests = freezed,
    Object? friends = freezed,
  }) {
    return _then(_$WhoAmIResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      firstname: freezed == firstname
          ? _value.firstname
          : firstname // ignore: cast_nullable_to_non_nullable
              as String?,
      lastname: freezed == lastname
          ? _value.lastname
          : lastname // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      sentFriendRequests: freezed == sentFriendRequests
          ? _value._sentFriendRequests
          : sentFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<FriendRequest>?,
      receivedFriendRequests: freezed == receivedFriendRequests
          ? _value._receivedFriendRequests
          : receivedFriendRequests // ignore: cast_nullable_to_non_nullable
              as List<FriendRequest>?,
      friends: freezed == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WhoAmIResponseImpl implements _WhoAmIResponse {
  const _$WhoAmIResponseImpl(
      {required this.id,
      required this.email,
      required this.username,
      this.firstname,
      this.lastname,
      required this.createdAt,
      required this.updatedAt,
      this.avatar,
      this.banner,
      final List<FriendRequest>? sentFriendRequests,
      final List<FriendRequest>? receivedFriendRequests,
      final List<dynamic>? friends})
      : _sentFriendRequests = sentFriendRequests,
        _receivedFriendRequests = receivedFriendRequests,
        _friends = friends;

  factory _$WhoAmIResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WhoAmIResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String email;
  @override
  final String username;
  @override
  final String? firstname;
  @override
  final String? lastname;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final UploadFile? avatar;
  @override
  final UploadFile? banner;
  final List<FriendRequest>? _sentFriendRequests;
  @override
  List<FriendRequest>? get sentFriendRequests {
    final value = _sentFriendRequests;
    if (value == null) return null;
    if (_sentFriendRequests is EqualUnmodifiableListView)
      return _sentFriendRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<FriendRequest>? _receivedFriendRequests;
  @override
  List<FriendRequest>? get receivedFriendRequests {
    final value = _receivedFriendRequests;
    if (value == null) return null;
    if (_receivedFriendRequests is EqualUnmodifiableListView)
      return _receivedFriendRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _friends;
  @override
  List<dynamic>? get friends {
    final value = _friends;
    if (value == null) return null;
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WhoAmIResponse(id: $id, email: $email, username: $username, firstname: $firstname, lastname: $lastname, createdAt: $createdAt, updatedAt: $updatedAt, avatar: $avatar, banner: $banner, sentFriendRequests: $sentFriendRequests, receivedFriendRequests: $receivedFriendRequests, friends: $friends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WhoAmIResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            const DeepCollectionEquality()
                .equals(other._sentFriendRequests, _sentFriendRequests) &&
            const DeepCollectionEquality().equals(
                other._receivedFriendRequests, _receivedFriendRequests) &&
            const DeepCollectionEquality().equals(other._friends, _friends));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      username,
      firstname,
      lastname,
      createdAt,
      updatedAt,
      avatar,
      banner,
      const DeepCollectionEquality().hash(_sentFriendRequests),
      const DeepCollectionEquality().hash(_receivedFriendRequests),
      const DeepCollectionEquality().hash(_friends));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WhoAmIResponseImplCopyWith<_$WhoAmIResponseImpl> get copyWith =>
      __$$WhoAmIResponseImplCopyWithImpl<_$WhoAmIResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WhoAmIResponseImplToJson(
      this,
    );
  }
}

abstract class _WhoAmIResponse implements WhoAmIResponse {
  const factory _WhoAmIResponse(
      {required final int id,
      required final String email,
      required final String username,
      final String? firstname,
      final String? lastname,
      required final String createdAt,
      required final String updatedAt,
      final UploadFile? avatar,
      final UploadFile? banner,
      final List<FriendRequest>? sentFriendRequests,
      final List<FriendRequest>? receivedFriendRequests,
      final List<dynamic>? friends}) = _$WhoAmIResponseImpl;

  factory _WhoAmIResponse.fromJson(Map<String, dynamic> json) =
      _$WhoAmIResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get email;
  @override
  String get username;
  @override
  String? get firstname;
  @override
  String? get lastname;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  UploadFile? get avatar;
  @override
  UploadFile? get banner;
  @override
  List<FriendRequest>? get sentFriendRequests;
  @override
  List<FriendRequest>? get receivedFriendRequests;
  @override
  List<dynamic>? get friends;
  @override
  @JsonKey(ignore: true)
  _$$WhoAmIResponseImplCopyWith<_$WhoAmIResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
