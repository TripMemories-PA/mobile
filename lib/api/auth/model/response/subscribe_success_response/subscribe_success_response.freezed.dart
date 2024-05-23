// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscribe_success_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscribeSuccessResponse _$SubscribeSuccessResponseFromJson(
    Map<String, dynamic> json) {
  return _SubscribeSuccessResponse.fromJson(json);
}

/// @nodoc
mixin _$SubscribeSuccessResponse {
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubscribeSuccessResponseCopyWith<SubscribeSuccessResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscribeSuccessResponseCopyWith<$Res> {
  factory $SubscribeSuccessResponseCopyWith(SubscribeSuccessResponse value,
          $Res Function(SubscribeSuccessResponse) then) =
      _$SubscribeSuccessResponseCopyWithImpl<$Res, SubscribeSuccessResponse>;
  @useResult
  $Res call(
      {String username,
      String email,
      String firstName,
      String lastName,
      String id});
}

/// @nodoc
class _$SubscribeSuccessResponseCopyWithImpl<$Res,
        $Val extends SubscribeSuccessResponse>
    implements $SubscribeSuccessResponseCopyWith<$Res> {
  _$SubscribeSuccessResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscribeSuccessResponseImplCopyWith<$Res>
    implements $SubscribeSuccessResponseCopyWith<$Res> {
  factory _$$SubscribeSuccessResponseImplCopyWith(
          _$SubscribeSuccessResponseImpl value,
          $Res Function(_$SubscribeSuccessResponseImpl) then) =
      __$$SubscribeSuccessResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String username,
      String email,
      String firstName,
      String lastName,
      String id});
}

/// @nodoc
class __$$SubscribeSuccessResponseImplCopyWithImpl<$Res>
    extends _$SubscribeSuccessResponseCopyWithImpl<$Res,
        _$SubscribeSuccessResponseImpl>
    implements _$$SubscribeSuccessResponseImplCopyWith<$Res> {
  __$$SubscribeSuccessResponseImplCopyWithImpl(
      _$SubscribeSuccessResponseImpl _value,
      $Res Function(_$SubscribeSuccessResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? id = null,
  }) {
    return _then(_$SubscribeSuccessResponseImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscribeSuccessResponseImpl implements _SubscribeSuccessResponse {
  const _$SubscribeSuccessResponseImpl(
      {required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.id});

  factory _$SubscribeSuccessResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscribeSuccessResponseImplFromJson(json);

  @override
  final String username;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String id;

  @override
  String toString() {
    return 'SubscribeSuccessResponse(username: $username, email: $email, firstName: $firstName, lastName: $lastName, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscribeSuccessResponseImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, username, email, firstName, lastName, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscribeSuccessResponseImplCopyWith<_$SubscribeSuccessResponseImpl>
      get copyWith => __$$SubscribeSuccessResponseImplCopyWithImpl<
          _$SubscribeSuccessResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscribeSuccessResponseImplToJson(
      this,
    );
  }
}

abstract class _SubscribeSuccessResponse implements SubscribeSuccessResponse {
  const factory _SubscribeSuccessResponse(
      {required final String username,
      required final String email,
      required final String firstName,
      required final String lastName,
      required final String id}) = _$SubscribeSuccessResponseImpl;

  factory _SubscribeSuccessResponse.fromJson(Map<String, dynamic> json) =
      _$SubscribeSuccessResponseImpl.fromJson;

  @override
  String get username;
  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$SubscribeSuccessResponseImplCopyWith<_$SubscribeSuccessResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
