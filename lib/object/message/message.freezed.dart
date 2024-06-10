// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  int get id => throw _privateConstructorUsedError;
  Profile get sender => throw _privateConstructorUsedError;
  Profile get receiver => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;
  UploadFile? get avatar => throw _privateConstructorUsedError;
  UploadFile? get banner => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {int id,
      Profile sender,
      Profile receiver,
      String message,
      DateTime sentAt,
      UploadFile? avatar,
      UploadFile? banner});

  $ProfileCopyWith<$Res> get sender;
  $ProfileCopyWith<$Res> get receiver;
  $UploadFileCopyWith<$Res>? get avatar;
  $UploadFileCopyWith<$Res>? get banner;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? receiver = null,
    Object? message = null,
    Object? sentAt = null,
    Object? avatar = freezed,
    Object? banner = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as Profile,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as Profile,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get sender {
    return $ProfileCopyWith<$Res>(_value.sender, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get receiver {
    return $ProfileCopyWith<$Res>(_value.receiver, (value) {
      return _then(_value.copyWith(receiver: value) as $Val);
    });
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
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      Profile sender,
      Profile receiver,
      String message,
      DateTime sentAt,
      UploadFile? avatar,
      UploadFile? banner});

  @override
  $ProfileCopyWith<$Res> get sender;
  @override
  $ProfileCopyWith<$Res> get receiver;
  @override
  $UploadFileCopyWith<$Res>? get avatar;
  @override
  $UploadFileCopyWith<$Res>? get banner;
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sender = null,
    Object? receiver = null,
    Object? message = null,
    Object? sentAt = null,
    Object? avatar = freezed,
    Object? banner = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as Profile,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as Profile,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      sentAt: null == sentAt
          ? _value.sentAt
          : sentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as UploadFile?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.sender,
      required this.receiver,
      required this.message,
      required this.sentAt,
      this.avatar,
      this.banner});

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final int id;
  @override
  final Profile sender;
  @override
  final Profile receiver;
  @override
  final String message;
  @override
  final DateTime sentAt;
  @override
  final UploadFile? avatar;
  @override
  final UploadFile? banner;

  @override
  String toString() {
    return 'Message(id: $id, sender: $sender, receiver: $receiver, message: $message, sentAt: $sentAt, avatar: $avatar, banner: $banner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.banner, banner) || other.banner == banner));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, sender, receiver, message, sentAt, avatar, banner);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final int id,
      required final Profile sender,
      required final Profile receiver,
      required final String message,
      required final DateTime sentAt,
      final UploadFile? avatar,
      final UploadFile? banner}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  int get id;
  @override
  Profile get sender;
  @override
  Profile get receiver;
  @override
  String get message;
  @override
  DateTime get sentAt;
  @override
  UploadFile? get avatar;
  @override
  UploadFile? get banner;
  @override
  @JsonKey(ignore: true)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
