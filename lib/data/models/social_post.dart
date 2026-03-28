class SocialPost {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String? imageUrl;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final DateTime createdAt;
  final List<String> tags;
  final String? location;

  const SocialPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    required this.createdAt,
    this.tags = const [],
    this.location,
  });

  SocialPost copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    String? imageUrl,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    DateTime? createdAt,
    List<String>? tags,
    String? location,
  }) {
    return SocialPost(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'location': location,
    };
  }

  factory SocialPost.fromMap(Map<String, dynamic> map) {
    return SocialPost(
      id: map['id'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      authorAvatar: map['authorAvatar'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'],
      likesCount: map['likesCount']?.toInt() ?? 0,
      commentsCount: map['commentsCount']?.toInt() ?? 0,
      isLiked: map['isLiked'] ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      tags: List<String>.from(map['tags'] ?? []),
      location: map['location'],
    );
  }
}

