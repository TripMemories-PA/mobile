// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_post_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdatePostQuery _$UpdatePostQueryFromJson(Map<String, dynamic> json) {
  return _UpdatePostQuery.fromJson(json);
}

/// @nodoc
mixin _$UpdatePostQuery {
  int get postId => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  int? get imageId => throw _privateConstructorUsedError;
  int? get poiId => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdatePostQueryCopyWith<UpdatePostQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePostQueryCopyWith<$Res> {
  factory $UpdatePostQueryCopyWith(
          UpdatePostQuery value, $Res Function(UpdatePostQuery) then) =
      _$UpdatePostQueryCopyWithImpl<$Res, UpdatePostQuery>;
  @useResult
  $Res call(
      {int postId, String? content, int? imageId, int? poiId, String? note});
}

/// @nodoc
class _$UpdatePostQueryCopyWithImpl<$Res, $Val extends UpdatePostQuery>
    implements $UpdatePostQueryCopyWith<$Res> {
  _$UpdatePostQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? content = freezed,
    Object? imageId = freezed,
    Object? poiId = freezed,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as int,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      imageId: freezed == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as int?,
      poiId: freezed == poiId
          ? _value.poiId
          : poiId // ignore: cast_nullable_to_non_nullable
              as int?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePostQueryImplCopyWith<$Res>
    implements $UpdatePostQueryCopyWith<$Res> {
  factory _$$UpdatePostQueryImplCopyWith(_$UpdatePostQueryImpl value,
          $Res Function(_$UpdatePostQueryImpl) then) =
      __$$UpdatePostQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int postId, String? content, int? imageId, int? poiId, String? note});
}

/// @nodoc
class __$$UpdatePostQueryImplCopyWithImpl<$Res>
    extends _$UpdatePostQueryCopyWithImpl<$Res, _$UpdatePostQueryImpl>
    implements _$$UpdatePostQueryImplCopyWith<$Res> {
  __$$UpdatePostQueryImplCopyWithImpl(
      _$UpdatePostQueryImpl _value, $Res Function(_$UpdatePostQueryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? content = freezed,
    Object? imageId = freezed,
    Object? poiId = freezed,
    Object? note = freezed,
  }) {
    return _then(_$UpdatePostQueryImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as int,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      imageId: freezed == imageId
          ? _value.imageId
          : imageId // ignore: cast_nullable_to_non_nullable
              as int?,
      poiId: freezed == poiId
          ? _value.poiId
          : poiId // ignore: cast_nullable_to_non_nullable
              as int?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$UpdatePostQueryImpl implements _UpdatePostQuery {
  const _$UpdatePostQueryImpl(
      {required this.postId,
      this.content,
      this.imageId,
      this.poiId,
      this.note});

  factory _$UpdatePostQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePostQueryImplFromJson(json);

  @override
  final int postId;
  @override
  final String? content;
  @override
  final int? imageId;
  @override
  final int? poiId;
  @override
  final String? note;

  @override
  String toString() {
    return 'UpdatePostQuery(postId: $postId, content: $content, imageId: $imageId, poiId: $poiId, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePostQueryImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageId, imageId) || other.imageId == imageId) &&
            (identical(other.poiId, poiId) || other.poiId == poiId) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, postId, content, imageId, poiId, note);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePostQueryImplCopyWith<_$UpdatePostQueryImpl> get copyWith =>
      __$$UpdatePostQueryImplCopyWithImpl<_$UpdatePostQueryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePostQueryImplToJson(
      this,
    );
  }
}

abstract class _UpdatePostQuery implements UpdatePostQuery {
  const factory _UpdatePostQuery(
      {required final int postId,
      final String? content,
      final int? imageId,
      final int? poiId,
      final String? note}) = _$UpdatePostQueryImpl;

  factory _UpdatePostQuery.fromJson(Map<String, dynamic> json) =
      _$UpdatePostQueryImpl.fromJson;

  @override
  int get postId;
  @override
  String? get content;
  @override
  int? get imageId;
  @override
  int? get poiId;
  @override
  String? get note;
  @override
  @JsonKey(ignore: true)
  _$$UpdatePostQueryImplCopyWith<_$UpdatePostQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
