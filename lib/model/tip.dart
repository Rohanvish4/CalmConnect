enum TipType { tip, resource, quote, awareness }

class Tip {
  final String id;
  final String message;
  final DateTime date;
  final TipType type;
  final String title;
  final String authorName;
  final String authorUID;
  final String? imageUrl;
  final List<String> tags;
  final int likes;
  final List<String> likedBy;

  Tip({
    required this.id,
    required this.message,
    required this.date,
    this.type = TipType.tip,
    required this.title,
    required this.authorName,
    required this.authorUID,
    this.imageUrl,
    this.tags = const [],
    this.likes = 0,
    this.likedBy = const [],
  });

  // Factory for creating from Firestore data
  factory Tip.fromMap(Map<String, dynamic> map, String id) {
    return Tip(
      id: id,
      message: map['message'] ?? '',
      title: map['title'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      type: TipType.values.firstWhere(
        (e) => e.toString() == 'TipType.${map['type']}',
        orElse: () => TipType.tip,
      ),
      authorName: map['authorName'] ?? '',
      authorUID: map['authorUID'] ?? '',
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
    );
  }

  // Convert to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'title': title,
      'timestamp': date.millisecondsSinceEpoch,
      'type': type.toString().split('.').last,
      'authorName': authorName,
      'authorUID': authorUID,
      'imageUrl': imageUrl,
      'tags': tags,
      'likes': likes,
      'likedBy': likedBy,
    };
  }

  // Helper method to get icon based on type
  String get typeIcon {
    switch (type) {
      case TipType.tip:
        return '💡';
      case TipType.resource:
        return '📚';
      case TipType.quote:
        return '💭';
      case TipType.awareness:
        return '🧠';
    }
  }

  // Helper method to get type display name
  String get typeDisplayName {
    switch (type) {
      case TipType.tip:
        return 'Mental Health Tip';
      case TipType.resource:
        return 'Resource';
      case TipType.quote:
        return 'Inspirational Quote';
      case TipType.awareness:
        return 'Mental Health Awareness';
    }
  }
}
