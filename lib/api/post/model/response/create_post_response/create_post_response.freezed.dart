// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreatePostResponse _$CreatePostResponseFromJson(Map<String, dynamic> json) {
  return _CreatePostResponse.fromJson(json);
}

/// @nodoc
mixin _$CreatePostResponse {
  int get createdById => throw _privateConstructorUsedError;
  int get poiId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get imageId => throw _privateConstructorUsedError;
  double get note => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatePostResponseCopyWith<CreatePostResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostResponseCopyWith<$Res> {
  factory $CreatePostResponseCopyWith(
          CreatePostResponse value, $Res Function(CreatePostResponse) then) =
      _$CreatePostResponseCopyWithImpl<$Res, CreatePostResponse>;
  @useResult
  $Res call(
      {int createdById,
      int poiId,
      String content,
      int imageId,
      double note,
      DateTime createdAt,
      DateTime updatedAt,
      int id});
}

/// @nodoc
class _$CreatePostResponseCopyWithImpl<$Res, $Val extends CreatePostResponse>
    implements $CreatePostResponseCopyWith<$Res> {
  _$CreatePostResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdById = null,
    Object? poiId = null,
    Object? content = null,
    Object? imageId = null,
    Object? note = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      createdById: null == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as int,
      poiId: null == poiId
          ? _value.poiId
          : poiId // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePostResponseImplCopyWith<$Res>
    implements $CreatePostResponseCopyWith<$Res> {
  factory _$$CreatePostResponseImplCopyWith(_$CreatePostResponseImpl value,
          $Res Function(_$CreatePostResponseImpl) then) =
      __$$CreatePostResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int createdById,
      int poiId,
      String content,
      int imageId,
      double note,
      DateTime createdAt,
      DateTime updatedAt,
      int id});
}

/// @nodoc
class __$$CreatePostResponseImplCopyWithImpl<$Res>
    extends _$CreatePostResponseCopyWithImpl<$Res, _$CreatePostResponseImpl>
    implements _$$CreatePostResponseImplCopyWith<$Res> {
  __$$CreatePostResponseImplCopyWithImpl(_$CreatePostResponseImpl _value,
      $Res Function(_$CreatePostResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdById = null,
    Object? poiId = null,
    Object? content = null,
    Object? imageId = null,
    Object? note = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? id = null,
  }) {
    return _then(_$CreatePostResponseImpl(
      createdById: null == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as int,
      poiId: null == poiId
          ? _value.poiId
          : poiId // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostResponseImpl implements _CreatePostResponse {
  const _$CreatePostResponseImpl(
      {required this.createdById,
      required this.poiId,
      required this.content,
      required this.imageId,
      required this.note,
      required this.createdAt,
      required this.updatedAt,
      required this.id});

  factory _$CreatePostResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostResponseImplFromJson(json);

  @override
  final int createdById;
  @override
  final int poiId;
  @override
  final String content;
  @override
  final int imageId;
  @override
  final double note;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int id;

  @override
  String toString() {
    return 'CreatePostResponse(createdById: $createdById, poiId: $poiId, content: $content, imageId: $imageId, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostResponseImpl &&
            (identical(other.createdById, createdById) ||
                other.createdById == createdById) &&
            (identical(other.poiId, poiId) || other.poiId == poiId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, createdById, poiId, content,
      imageId, note, createdAt, updatedAt, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostResponseImplCopyWith<_$CreatePostResponseImpl> get copyWith =>
      __$$CreatePostResponseImplCopyWithImpl<_$CreatePostResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostResponseImplToJson(
      this,
    );
  }
}

abstract class _CreatePostResponse implements CreatePostResponse {
  const factory _CreatePostResponse(
      {required final int createdById,
      required final int poiId,
      required final String content,
      required final int imageId,
      required final double note,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final int id}) = _$CreatePostResponseImpl;

  factory _CreatePostResponse.fromJson(Map<String, dynamic> json) =
      _$CreatePostResponseImpl.fromJson;

  @override
  int get createdById;
  @override
  int get poiId;
  @override
  String get content;
  @override
  int get imageId;
  @override
  double get note;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int get id;
  @override
  @JsonKey(ignore: true)
  _$$CreatePostResponseImplCopyWith<_$CreatePostResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
