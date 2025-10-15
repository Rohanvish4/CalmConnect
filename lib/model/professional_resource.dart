class ProfessionalResource {
  final String id;
  final String name;
  final String role;
  final String imageUrl; // Could be asset or network
  final double rating;
  final int reviews;

  ProfessionalResource({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });
}

enum ResourceCategory { selfCare, peerSupport, directory, dailyTip }

extension ResourceCategoryMeta on ResourceCategory {
  String get label {
    switch (this) {
      case ResourceCategory.selfCare:
        return 'Self-care';
      case ResourceCategory.peerSupport:
        return 'Peer Support';
      case ResourceCategory.directory:
        return 'Resources';
      case ResourceCategory.dailyTip:
        return 'Daily Tip';
    }
  }

  String get description {
    switch (this) {
      case ResourceCategory.selfCare:
        return 'Daily tools for mindfulness and wellbeing.';
      case ResourceCategory.peerSupport:
        return 'Connect with others via chats and forums.';
      case ResourceCategory.directory:
        return 'Find professionals and organizations.';
      case ResourceCategory.dailyTip:
        return 'Gentle reminders to take care of you.';
    }
  }
}
