// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreatePostQuery _$CreatePostQueryFromJson(Map<String, dynamic> json) {
  return _CreatePostQuery.fromJson(json);
}

/// @nodoc
mixin _$CreatePostQuery {
  String get content => throw _privateConstructorUsedError;
  int get imageId => throw _privateConstructorUsedError;
  int get poiId => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatePostQueryCopyWith<CreatePostQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostQueryCopyWith<$Res> {
  factory $CreatePostQueryCopyWith(
          CreatePostQuery value, $Res Function(CreatePostQuery) then) =
      _$CreatePostQueryCopyWithImpl<$Res, CreatePostQuery>;
  @useResult
  $Res call({String content, int imageId, int poiId, String note});
}

/// @nodoc
class _$CreatePostQueryCopyWithImpl<$Res, $Val extends CreatePostQuery>
    implements $CreatePostQueryCopyWith<$Res> {
  _$CreatePostQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? imageId = null,
    Object? poiId = null,
    Object? note = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as int,
      poiId: null == poiId
          ? _value.poiId
          : poiId // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePostQueryImplCopyWith<$Res>
    implements $CreatePostQueryCopyWith<$Res> {
  factory _$$CreatePostQueryImplCopyWith(_$CreatePostQueryImpl value,
          $Res Function(_$CreatePostQueryImpl) then) =
      __$$CreatePostQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content, int imageId, int poiId, String note});
}

/// @nodoc
class __$$CreatePostQueryImplCopyWithImpl<$Res>
    extends _$CreatePostQueryCopyWithImpl<$Res, _$CreatePostQueryImpl>
    implements _$$CreatePostQueryImplCopyWith<$Res> {
  __$$CreatePostQueryImplCopyWithImpl(
      _$CreatePostQueryImpl _value, $Res Function(_$CreatePostQueryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? imageId = null,
    Object? poiId = null,
    Object? note = null,
  }) {
    return _then(_$CreatePostQueryImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageId: null == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as int,
      poiId: null == poiId
          ? _value.poiId
          : poiId // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$CreatePostQueryImpl implements _CreatePostQuery {
  const _$CreatePostQueryImpl(
      {required this.content,
      required this.imageId,
      required this.poiId,
      required this.note});

  factory _$CreatePostQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostQueryImplFromJson(json);

  @override
  final String content;
  @override
  final int imageId;
  @override
  final int poiId;
  @override
  final String note;

  @override
  String toString() {
    return 'CreatePostQuery(content: $content, imageId: $imageId, poiId: $poiId, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostQueryImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.poiId, poiId) || other.poiId == poiId) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, content, imageId, poiId, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostQueryImplCopyWith<_$CreatePostQueryImpl> get copyWith =>
      __$$CreatePostQueryImplCopyWithImpl<_$CreatePostQueryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostQueryImplToJson(
      this,
    );
  }
}

abstract class _CreatePostQuery implements CreatePostQuery {
  const factory _CreatePostQuery(
      {required final String content,
      required final int imageId,
      required final int poiId,
      required final String note}) = _$CreatePostQueryImpl;

  factory _CreatePostQuery.fromJson(Map<String, dynamic> json) =
      _$CreatePostQueryImpl.fromJson;

  @override
  String get content;
  @override
  int get imageId;
  @override
  int get poiId;
  @override
  String get note;
  @override
  @JsonKey(ignore: true)
  _$$CreatePostQueryImplCopyWith<_$CreatePostQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
