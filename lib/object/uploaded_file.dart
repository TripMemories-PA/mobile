class UploadFile {
  UploadFile({
    required this.id,
    required this.filename,
    required this.url,
    required this.mimeType,
    required this.createdAt,
    this.updatedAt,
  });

  factory UploadFile.fromJson(Map<String, dynamic> json) {
    return UploadFile(
      id: json['id'] as int,
      filename: json['filename'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'filename': filename,
      'url': url,
      'mimeType': mimeType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  int id;
  String filename;
  String url;
  String mimeType;
  DateTime createdAt;
  DateTime? updatedAt;
}
