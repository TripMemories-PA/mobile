import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploadedFile.freezed.dart';
part 'uploadedFile.g.dart';

@Freezed()
class UploadFile with _$UploadFile {
  const factory UploadFile({
    required int id,
    required String filename,
    required String url,
    required String mimeType,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UploadFile;

  factory UploadFile.fromJson(Map<String, dynamic> json) =>
      _$UploadFileFromJson(json);
}
