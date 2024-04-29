// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_element_login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserElementLogInResponse _$UserElementLogInResponseFromJson(
    Map<String, dynamic> json) {
  return _UserElementLogInResponse.fromJson(json);
}

/// @nodoc
mixin _$UserElementLogInResponse {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserElementLogInResponseCopyWith<UserElementLogInResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserElementLogInResponseCopyWith<$Res> {
  factory $UserElementLogInResponseCopyWith(UserElementLogInResponse value,
          $Res Function(UserElementLogInResponse) then) =
      _$UserElementLogInResponseCopyWithImpl<$Res, UserElementLogInResponse>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$UserElementLogInResponseCopyWithImpl<$Res,
        $Val extends UserElementLogInResponse>
    implements $UserElementLogInResponseCopyWith<$Res> {
  _$UserElementLogInResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserElementLogInResponseImplCopyWith<$Res>
    implements $UserElementLogInResponseCopyWith<$Res> {
  factory _$$UserElementLogInResponseImplCopyWith(
          _$UserElementLogInResponseImpl value,
          $Res Function(_$UserElementLogInResponseImpl) then) =
      __$$UserElementLogInResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$UserElementLogInResponseImplCopyWithImpl<$Res>
    extends _$UserElementLogInResponseCopyWithImpl<$Res,
        _$UserElementLogInResponseImpl>
    implements _$$UserElementLogInResponseImplCopyWith<$Res> {
  __$$UserElementLogInResponseImplCopyWithImpl(
      _$UserElementLogInResponseImpl _value,
      $Res Function(_$UserElementLogInResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$UserElementLogInResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserElementLogInResponseImpl implements _UserElementLogInResponse {
  const _$UserElementLogInResponseImpl({required this.id, required this.name});

  factory _$UserElementLogInResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserElementLogInResponseImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'UserElementLogInResponse(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserElementLogInResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserElementLogInResponseImplCopyWith<_$UserElementLogInResponseImpl>
      get copyWith => __$$UserElementLogInResponseImplCopyWithImpl<
          _$UserElementLogInResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserElementLogInResponseImplToJson(
      this,
    );
  }
}

abstract class _UserElementLogInResponse implements UserElementLogInResponse {
  const factory _UserElementLogInResponse(
      {required final int id,
      required final String name}) = _$UserElementLogInResponseImpl;

  factory _UserElementLogInResponse.fromJson(Map<String, dynamic> json) =
      _$UserElementLogInResponseImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$UserElementLogInResponseImplCopyWith<_$UserElementLogInResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
