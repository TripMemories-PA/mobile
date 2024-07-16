import '../../../../object/uploaded_file.dart';

class PostQuestImageResponse {
  const PostQuestImageResponse({
    required this.labels,
    this.file,
  });

  factory PostQuestImageResponse.fromJson(Map<String, dynamic> json) {
    return PostQuestImageResponse(
      labels: List<String>.from(json['labels']),
      file: UploadFile.fromJson(json['file']),
    );
  }
  final List<String> labels;
  final UploadFile? file;
}
