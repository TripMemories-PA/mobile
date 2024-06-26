// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_success_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthSuccessResponse _$AuthSuccessResponseFromJson(Map<String, dynamic> json) {
  return _AuthSuccessResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthSuccessResponse {
  String get type => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthSuccessResponseCopyWith<AuthSuccessResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSuccessResponseCopyWith<$Res> {
  factory $AuthSuccessResponseCopyWith(
          AuthSuccessResponse value, $Res Function(AuthSuccessResponse) then) =
      _$AuthSuccessResponseCopyWithImpl<$Res, AuthSuccessResponse>;
  @useResult
  $Res call({String type, String token});
}

/// @nodoc
class _$AuthSuccessResponseCopyWithImpl<$Res, $Val extends AuthSuccessResponse>
    implements $AuthSuccessResponseCopyWith<$Res> {
  _$AuthSuccessResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthSuccessResponseImplCopyWith<$Res>
    implements $AuthSuccessResponseCopyWith<$Res> {
  factory _$$AuthSuccessResponseImplCopyWith(_$AuthSuccessResponseImpl value,
          $Res Function(_$AuthSuccessResponseImpl) then) =
      __$$AuthSuccessResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String token});
}

/// @nodoc
class __$$AuthSuccessResponseImplCopyWithImpl<$Res>
    extends _$AuthSuccessResponseCopyWithImpl<$Res, _$AuthSuccessResponseImpl>
    implements _$$AuthSuccessResponseImplCopyWith<$Res> {
  __$$AuthSuccessResponseImplCopyWithImpl(_$AuthSuccessResponseImpl _value,
      $Res Function(_$AuthSuccessResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? token = null,
  }) {
    return _then(_$AuthSuccessResponseImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthSuccessResponseImpl implements _AuthSuccessResponse {
  const _$AuthSuccessResponseImpl({required this.type, required this.token});

  factory _$AuthSuccessResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthSuccessResponseImplFromJson(json);

  @override
  final String type;
  @override
  final String token;

  @override
  String toString() {
    return 'AuthSuccessResponse(type: $type, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSuccessResponseImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, token);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSuccessResponseImplCopyWith<_$AuthSuccessResponseImpl> get copyWith =>
      __$$AuthSuccessResponseImplCopyWithImpl<_$AuthSuccessResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthSuccessResponseImplToJson(
      this,
    );
  }
}

abstract class _AuthSuccessResponse implements AuthSuccessResponse {
  const factory _AuthSuccessResponse(
      {required final String type,
      required final String token}) = _$AuthSuccessResponseImpl;

  factory _AuthSuccessResponse.fromJson(Map<String, dynamic> json) =
      _$AuthSuccessResponseImpl.fromJson;

  @override
  String get type;
  @override
  String get token;
  @override
  @JsonKey(ignore: true)
  _$$AuthSuccessResponseImplCopyWith<_$AuthSuccessResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
