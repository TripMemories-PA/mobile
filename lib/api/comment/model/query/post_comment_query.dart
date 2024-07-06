class PostCommentQuery {
  PostCommentQuery({
    required this.content,
    required this.postId,
  });

  factory PostCommentQuery.fromJson(Map<String, dynamic> json) {
    return PostCommentQuery(
      content: json['content'],
      postId: json['postId'],
    );
  }

  Map<String, Object> toJson() {
    return {
      'content': content,
      'postId': postId,
    };
  }

  String content;
  int postId;
}
