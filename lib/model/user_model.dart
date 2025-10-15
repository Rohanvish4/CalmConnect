

enum UserType { peer, counsellor }

class UserModel {
  final String userUID;
  final String name;
  final String email;
  final UserType userType;
  final bool isOnline;
  
  // Extended profile fields
  final String bio;
  final String occupation;
  final String specialization; // For counsellors
  final int experienceYears; // For counsellors
  final String qualifications; // For counsellors
  final double rating; // For counsellors (0-5)
  final int consultationCount; // For counsellors
  final bool isAvailableForConsultation; // For counsellors

  UserModel({
    this.userUID = "",
    this.name = "",
    this.email = "",
    this.userType = UserType.peer,
    this.isOnline = false,
    this.bio = "",
    this.occupation = "",
    this.specialization = "",
    this.experienceYears = 0,
    this.qualifications = "",
    this.rating = 0.0,
    this.consultationCount = 0,
    this.isAvailableForConsultation = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userUID: json['userUID'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    userType: UserType.values.firstWhere(
      (e) => e.name == json['userType'], 
      orElse: () => UserType.peer,
    ),
    isOnline: json['isOnline'] ?? false,
    bio: json['bio'] ?? '',
    occupation: json['occupation'] ?? '',
    specialization: json['specialization'] ?? '',
    experienceYears: json['experienceYears'] ?? 0,
    qualifications: json['qualifications'] ?? '',
    rating: (json['rating'] ?? 0.0).toDouble(),
    consultationCount: json['consultationCount'] ?? 0,
    isAvailableForConsultation: json['isAvailableForConsultation'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'userUID': userUID,
    'name': name,
    'email': email,
    'userType': userType.name,
    'isOnline': isOnline,
    'lastSeen': DateTime.now().millisecondsSinceEpoch,
    'bio': bio,
    'occupation': occupation,
    'specialization': specialization,
    'experienceYears': experienceYears,
    'qualifications': qualifications,
    'rating': rating,
    'consultationCount': consultationCount,
    'isAvailableForConsultation': isAvailableForConsultation,
  };

  // Helper method to check if counsellor is featured (high rating + experience)
  bool get isFeatured => userType == UserType.counsellor && 
                        rating >= 4.0 && 
                        experienceYears >= 2;
}

