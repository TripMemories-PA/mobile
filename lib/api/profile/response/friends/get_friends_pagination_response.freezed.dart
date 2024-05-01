// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_friends_pagination_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GetFriendsPaginationResponse _$GetFriendsPaginationResponseFromJson(
    Map<String, dynamic> json) {
  return _GetFriendsPaginationResponse.fromJson(json);
}

/// @nodoc
mixin _$GetFriendsPaginationResponse {
  Meta get meta => throw _privateConstructorUsedError;
  List<Data> get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetFriendsPaginationResponseCopyWith<GetFriendsPaginationResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetFriendsPaginationResponseCopyWith<$Res> {
  factory $GetFriendsPaginationResponseCopyWith(
          GetFriendsPaginationResponse value,
          $Res Function(GetFriendsPaginationResponse) then) =
      _$GetFriendsPaginationResponseCopyWithImpl<$Res,
          GetFriendsPaginationResponse>;
  @useResult
  $Res call({Meta meta, List<Data> data});

  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$GetFriendsPaginationResponseCopyWithImpl<$Res,
        $Val extends GetFriendsPaginationResponse>
    implements $GetFriendsPaginationResponseCopyWith<$Res> {
  _$GetFriendsPaginationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Data>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MetaCopyWith<$Res> get meta {
    return $MetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GetFriendsPaginationResponseImplCopyWith<$Res>
    implements $GetFriendsPaginationResponseCopyWith<$Res> {
  factory _$$GetFriendsPaginationResponseImplCopyWith(
          _$GetFriendsPaginationResponseImpl value,
          $Res Function(_$GetFriendsPaginationResponseImpl) then) =
      __$$GetFriendsPaginationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Meta meta, List<Data> data});

  @override
  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$GetFriendsPaginationResponseImplCopyWithImpl<$Res>
    extends _$GetFriendsPaginationResponseCopyWithImpl<$Res,
        _$GetFriendsPaginationResponseImpl>
    implements _$$GetFriendsPaginationResponseImplCopyWith<$Res> {
  __$$GetFriendsPaginationResponseImplCopyWithImpl(
      _$GetFriendsPaginationResponseImpl _value,
      $Res Function(_$GetFriendsPaginationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meta = null,
    Object? data = null,
  }) {
    return _then(_$GetFriendsPaginationResponseImpl(
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Data>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GetFriendsPaginationResponseImpl
    implements _GetFriendsPaginationResponse {
  const _$GetFriendsPaginationResponseImpl(
      {required this.meta, required final List<Data> data})
      : _data = data;

  factory _$GetFriendsPaginationResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$GetFriendsPaginationResponseImplFromJson(json);

  @override
  final Meta meta;
  final List<Data> _data;
  @override
  List<Data> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'GetFriendsPaginationResponse(meta: $meta, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetFriendsPaginationResponseImpl &&
            (identical(other.meta, meta) || other.meta == meta) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, meta, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GetFriendsPaginationResponseImplCopyWith<
          _$GetFriendsPaginationResponseImpl>
      get copyWith => __$$GetFriendsPaginationResponseImplCopyWithImpl<
          _$GetFriendsPaginationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GetFriendsPaginationResponseImplToJson(
      this,
    );
  }
}

abstract class _GetFriendsPaginationResponse
    implements GetFriendsPaginationResponse {
  const factory _GetFriendsPaginationResponse(
      {required final Meta meta,
      required final List<Data> data}) = _$GetFriendsPaginationResponseImpl;

  factory _GetFriendsPaginationResponse.fromJson(Map<String, dynamic> json) =
      _$GetFriendsPaginationResponseImpl.fromJson;

  @override
  Meta get meta;
  @override
  List<Data> get data;
  @override
  @JsonKey(ignore: true)
  _$$GetFriendsPaginationResponseImplCopyWith<
          _$GetFriendsPaginationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return _Meta.fromJson(json);
}

/// @nodoc
mixin _$Meta {
  int get total => throw _privateConstructorUsedError;
  int get perPage => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get lastPage => throw _privateConstructorUsedError;
  int get firstPage => throw _privateConstructorUsedError;
  String get firstPageUrl => throw _privateConstructorUsedError;
  String get lastPageUrl => throw _privateConstructorUsedError;
  String? get nextPageUrl => throw _privateConstructorUsedError;
  String? get previousPageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetaCopyWith<Meta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaCopyWith<$Res> {
  factory $MetaCopyWith(Meta value, $Res Function(Meta) then) =
      _$MetaCopyWithImpl<$Res, Meta>;
  @useResult
  $Res call(
      {int total,
      int perPage,
      int currentPage,
      int lastPage,
      int firstPage,
      String firstPageUrl,
      String lastPageUrl,
      String? nextPageUrl,
      String? previousPageUrl});
}

/// @nodoc
class _$MetaCopyWithImpl<$Res, $Val extends Meta>
    implements $MetaCopyWith<$Res> {
  _$MetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? perPage = null,
    Object? currentPage = null,
    Object? lastPage = null,
    Object? firstPage = null,
    Object? firstPageUrl = null,
    Object? lastPageUrl = null,
    Object? nextPageUrl = freezed,
    Object? previousPageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      firstPage: null == firstPage
          ? _value.firstPage
          : firstPage // ignore: cast_nullable_to_non_nullable
              as int,
      firstPageUrl: null == firstPageUrl
          ? _value.firstPageUrl
          : firstPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lastPageUrl: null == lastPageUrl
          ? _value.lastPageUrl
          : lastPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      previousPageUrl: freezed == previousPageUrl
          ? _value.previousPageUrl
          : previousPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetaImplCopyWith<$Res> implements $MetaCopyWith<$Res> {
  factory _$$MetaImplCopyWith(
          _$MetaImpl value, $Res Function(_$MetaImpl) then) =
      __$$MetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      int perPage,
      int currentPage,
      int lastPage,
      int firstPage,
      String firstPageUrl,
      String lastPageUrl,
      String? nextPageUrl,
      String? previousPageUrl});
}

/// @nodoc
class __$$MetaImplCopyWithImpl<$Res>
    extends _$MetaCopyWithImpl<$Res, _$MetaImpl>
    implements _$$MetaImplCopyWith<$Res> {
  __$$MetaImplCopyWithImpl(_$MetaImpl _value, $Res Function(_$MetaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? perPage = null,
    Object? currentPage = null,
    Object? lastPage = null,
    Object? firstPage = null,
    Object? firstPageUrl = null,
    Object? lastPageUrl = null,
    Object? nextPageUrl = freezed,
    Object? previousPageUrl = freezed,
  }) {
    return _then(_$MetaImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      firstPage: null == firstPage
          ? _value.firstPage
          : firstPage // ignore: cast_nullable_to_non_nullable
              as int,
      firstPageUrl: null == firstPageUrl
          ? _value.firstPageUrl
          : firstPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      lastPageUrl: null == lastPageUrl
          ? _value.lastPageUrl
          : lastPageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      previousPageUrl: freezed == previousPageUrl
          ? _value.previousPageUrl
          : previousPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaImpl implements _Meta {
  const _$MetaImpl(
      {required this.total,
      required this.perPage,
      required this.currentPage,
      required this.lastPage,
      required this.firstPage,
      required this.firstPageUrl,
      required this.lastPageUrl,
      required this.nextPageUrl,
      required this.previousPageUrl});

  factory _$MetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaImplFromJson(json);

  @override
  final int total;
  @override
  final int perPage;
  @override
  final int currentPage;
  @override
  final int lastPage;
  @override
  final int firstPage;
  @override
  final String firstPageUrl;
  @override
  final String lastPageUrl;
  @override
  final String? nextPageUrl;
  @override
  final String? previousPageUrl;

  @override
  String toString() {
    return 'Meta(total: $total, perPage: $perPage, currentPage: $currentPage, lastPage: $lastPage, firstPage: $firstPage, firstPageUrl: $firstPageUrl, lastPageUrl: $lastPageUrl, nextPageUrl: $nextPageUrl, previousPageUrl: $previousPageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.firstPage, firstPage) ||
                other.firstPage == firstPage) &&
            (identical(other.firstPageUrl, firstPageUrl) ||
                other.firstPageUrl == firstPageUrl) &&
            (identical(other.lastPageUrl, lastPageUrl) ||
                other.lastPageUrl == lastPageUrl) &&
            (identical(other.nextPageUrl, nextPageUrl) ||
                other.nextPageUrl == nextPageUrl) &&
            (identical(other.previousPageUrl, previousPageUrl) ||
                other.previousPageUrl == previousPageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      total,
      perPage,
      currentPage,
      lastPage,
      firstPage,
      firstPageUrl,
      lastPageUrl,
      nextPageUrl,
      previousPageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      __$$MetaImplCopyWithImpl<_$MetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaImplToJson(
      this,
    );
  }
}

abstract class _Meta implements Meta {
  const factory _Meta(
      {required final int total,
      required final int perPage,
      required final int currentPage,
      required final int lastPage,
      required final int firstPage,
      required final String firstPageUrl,
      required final String lastPageUrl,
      required final String? nextPageUrl,
      required final String? previousPageUrl}) = _$MetaImpl;

  factory _Meta.fromJson(Map<String, dynamic> json) = _$MetaImpl.fromJson;

  @override
  int get total;
  @override
  int get perPage;
  @override
  int get currentPage;
  @override
  int get lastPage;
  @override
  int get firstPage;
  @override
  String get firstPageUrl;
  @override
  String get lastPageUrl;
  @override
  String? get nextPageUrl;
  @override
  String? get previousPageUrl;
  @override
  @JsonKey(ignore: true)
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Data _$DataFromJson(Map<String, dynamic> json) {
  return _Data.fromJson(json);
}

/// @nodoc
mixin _$Data {
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataCopyWith<$Res> {
  factory $DataCopyWith(Data value, $Res Function(Data) then) =
      _$DataCopyWithImpl<$Res, Data>;
}

/// @nodoc
class _$DataCopyWithImpl<$Res, $Val extends Data>
    implements $DataCopyWith<$Res> {
  _$DataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DataImplCopyWith<$Res> {
  factory _$$DataImplCopyWith(
          _$DataImpl value, $Res Function(_$DataImpl) then) =
      __$$DataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DataImplCopyWithImpl<$Res>
    extends _$DataCopyWithImpl<$Res, _$DataImpl>
    implements _$$DataImplCopyWith<$Res> {
  __$$DataImplCopyWithImpl(_$DataImpl _value, $Res Function(_$DataImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$DataImpl implements _Data {
  const _$DataImpl();

  factory _$DataImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataImplFromJson(json);

  @override
  String toString() {
    return 'Data()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DataImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$DataImplToJson(
      this,
    );
  }
}

abstract class _Data implements Data {
  const factory _Data() = _$DataImpl;

  factory _Data.fromJson(Map<String, dynamic> json) = _$DataImpl.fromJson;
}
