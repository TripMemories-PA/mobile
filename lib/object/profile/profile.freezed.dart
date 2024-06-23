// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String? get firstname => throw _privateConstructorUsedError;
  String? get lastname => throw _privateConstructorUsedError;
  bool? get isFriend => throw _privateConstructorUsedError;
  bool? get isSentFriendRequest => throw _privateConstructorUsedError;
  bool? get isReceivedFriendRequest => throw _privateConstructorUsedError;
  UploadFile? get avatar => throw _privateConstructorUsedError;
  UploadFile? get banner => throw _privateConstructorUsedError;
  int? get poisCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
  @useResult
  $Res call(
      {int id,
      String email,
      String username,
      String? firstname,
      String? lastname,
      bool? isFriend,
      bool? isSentFriendRequest,
      bool? isReceivedFriendRequest,
      UploadFile? avatar,
      UploadFile? banner,
      int? poisCount});

  $UploadFileCopyWith<$Res>? get avatar;
  $UploadFileCopyWith<$Res>? get banner;
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

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
    Object? isFriend = freezed,
    Object? isSentFriendRequest = freezed,
    Object? isReceivedFriendRequest = freezed,
    Object? avatar = freezed,
    Object? banner = freezed,
    Object? poisCount = freezed,
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
      isFriend: freezed == isFriend
          ? _value.isFriend
          : isFriend // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSentFriendRequest: freezed == isSentFriendRequest
          ? _value.isSentFriendRequest
          : isSentFriendRequest // ignore: cast_nullable_to_non_nullable
              as bool?,
      isReceivedFriendRequest: freezed == isReceivedFriendRequest
          ? _value.isReceivedFriendRequest
          : isReceivedFriendRequest // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      poisCount: freezed == poisCount
          ? _value.poisCount
          : poisCount // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
          _$ProfileImpl value, $Res Function(_$ProfileImpl) then) =
      __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String email,
      String username,
      String? firstname,
      String? lastname,
      bool? isFriend,
      bool? isSentFriendRequest,
      bool? isReceivedFriendRequest,
      UploadFile? avatar,
      UploadFile? banner,
      int? poisCount});

  @override
  $UploadFileCopyWith<$Res>? get avatar;
  @override
  $UploadFileCopyWith<$Res>? get banner;
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
      _$ProfileImpl _value, $Res Function(_$ProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? firstname = freezed,
    Object? lastname = freezed,
    Object? isFriend = freezed,
    Object? isSentFriendRequest = freezed,
    Object? isReceivedFriendRequest = freezed,
    Object? avatar = freezed,
    Object? banner = freezed,
    Object? poisCount = freezed,
  }) {
    return _then(_$ProfileImpl(
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
      isFriend: freezed == isFriend
          ? _value.isFriend
          : isFriend // ignore: cast_nullable_to_non_nullable
              as bool?,
      isSentFriendRequest: freezed == isSentFriendRequest
          ? _value.isSentFriendRequest
          : isSentFriendRequest // ignore: cast_nullable_to_non_nullable
              as bool?,
      isReceivedFriendRequest: freezed == isReceivedFriendRequest
          ? _value.isReceivedFriendRequest
          : isReceivedFriendRequest // ignore: cast_nullable_to_non_nullable
              as bool?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      poisCount: freezed == poisCount
          ? _value.poisCount
          : poisCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ProfileImpl implements _Profile {
  const _$ProfileImpl(
      {required this.id,
      required this.email,
      required this.username,
      required this.firstname,
      required this.lastname,
      required this.isFriend,
      required this.isSentFriendRequest,
      required this.isReceivedFriendRequest,
      this.avatar,
      this.banner,
      required this.poisCount});

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

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
  final bool? isFriend;
  @override
  final bool? isSentFriendRequest;
  @override
  final bool? isReceivedFriendRequest;
  @override
  final UploadFile? avatar;
  @override
  final UploadFile? banner;
  @override
  final int? poisCount;

  @override
  String toString() {
    return 'Profile(id: $id, email: $email, username: $username, firstname: $firstname, lastname: $lastname, isFriend: $isFriend, isSentFriendRequest: $isSentFriendRequest, isReceivedFriendRequest: $isReceivedFriendRequest, avatar: $avatar, banner: $banner, poisCount: $poisCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.firstname, firstname) ||
                other.firstname == firstname) &&
            (identical(other.lastname, lastname) ||
                other.lastname == lastname) &&
            (identical(other.isFriend, isFriend) ||
                other.isFriend == isFriend) &&
            (identical(other.isSentFriendRequest, isSentFriendRequest) ||
                other.isSentFriendRequest == isSentFriendRequest) &&
            (identical(
                    other.isReceivedFriendRequest, isReceivedFriendRequest) ||
                other.isReceivedFriendRequest == isReceivedFriendRequest) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.poisCount, poisCount) ||
                other.poisCount == poisCount));
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
      isFriend,
      isSentFriendRequest,
      isReceivedFriendRequest,
      avatar,
      banner,
      poisCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(
      this,
    );
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
      {required final int id,
      required final String email,
      required final String username,
      required final String? firstname,
      required final String? lastname,
      required final bool? isFriend,
      required final bool? isSentFriendRequest,
      required final bool? isReceivedFriendRequest,
      final UploadFile? avatar,
      final UploadFile? banner,
      required final int? poisCount}) = _$ProfileImpl;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

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
  bool? get isFriend;
  @override
  bool? get isSentFriendRequest;
  @override
  bool? get isReceivedFriendRequest;
  @override
  UploadFile? get avatar;
  @override
  UploadFile? get banner;
  @override
  int? get poisCount;
  @override
  @JsonKey(ignore: true)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
