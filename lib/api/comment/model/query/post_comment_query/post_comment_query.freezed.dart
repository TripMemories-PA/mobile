// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_comment_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostCommentQuery _$PostCommentQueryFromJson(Map<String, dynamic> json) {
  return _PostCommentQuery.fromJson(json);
}

/// @nodoc
mixin _$PostCommentQuery {
  String get content => throw _privateConstructorUsedError;
  int get postId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCommentQueryCopyWith<PostCommentQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCommentQueryCopyWith<$Res> {
  factory $PostCommentQueryCopyWith(
          PostCommentQuery value, $Res Function(PostCommentQuery) then) =
      _$PostCommentQueryCopyWithImpl<$Res, PostCommentQuery>;
  @useResult
  $Res call({String content, int postId});
}

/// @nodoc
class _$PostCommentQueryCopyWithImpl<$Res, $Val extends PostCommentQuery>
    implements $PostCommentQueryCopyWith<$Res> {
  _$PostCommentQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? postId = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostCommentQueryImplCopyWith<$Res>
    implements $PostCommentQueryCopyWith<$Res> {
  factory _$$PostCommentQueryImplCopyWith(_$PostCommentQueryImpl value,
          $Res Function(_$PostCommentQueryImpl) then) =
      __$$PostCommentQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content, int postId});
}

/// @nodoc
class __$$PostCommentQueryImplCopyWithImpl<$Res>
    extends _$PostCommentQueryCopyWithImpl<$Res, _$PostCommentQueryImpl>
    implements _$$PostCommentQueryImplCopyWith<$Res> {
  __$$PostCommentQueryImplCopyWithImpl(_$PostCommentQueryImpl _value,
      $Res Function(_$PostCommentQueryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? postId = null,
  }) {
    return _then(_$PostCommentQueryImpl(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PostCommentQueryImpl implements _PostCommentQuery {
  const _$PostCommentQueryImpl({required this.content, required this.postId});

  factory _$PostCommentQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCommentQueryImplFromJson(json);

  @override
  final String content;
  @override
  final int postId;

  @override
  String toString() {
    return 'PostCommentQuery(content: $content, postId: $postId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCommentQueryImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.postId, postId) || other.postId == postId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, content, postId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCommentQueryImplCopyWith<_$PostCommentQueryImpl> get copyWith =>
      __$$PostCommentQueryImplCopyWithImpl<_$PostCommentQueryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCommentQueryImplToJson(
      this,
    );
  }
}

abstract class _PostCommentQuery implements PostCommentQuery {
  const factory _PostCommentQuery(
      {required final String content,
      required final int postId}) = _$PostCommentQueryImpl;

  factory _PostCommentQuery.fromJson(Map<String, dynamic> json) =
      _$PostCommentQueryImpl.fromJson;

  @override
  String get content;
  @override
  int get postId;
  @override
  @JsonKey(ignore: true)
  _$$PostCommentQueryImplCopyWith<_$PostCommentQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
