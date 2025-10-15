enum ProfessionalType {
  therapist,
  psychiatrist,
  counselor,
  supportGroup,
  crisisCenter,
  wellnessCenter,
}

enum InsuranceType {
  aetna,
  blueCross,
  cigna,
  unitedHealth,
  medicare,
  medicaid,
  outOfNetwork,
  slidingScale,
}

enum TherapyType {
  cbt, // Cognitive Behavioral Therapy
  dbt, // Dialectical Behavior Therapy
  emdr, // Eye Movement Desensitization and Reprocessing
  familyTherapy,
  groupTherapy,
  artTherapy,
  mindfulness,
  psychodynamic,
  humanistic,
}

enum ServiceMode {
  inPerson,
  telehealth,
  both,
}

enum Language {
  english,
  spanish,
  french,
  mandarin,
  arabic,
  tagalog,
  vietnamese,
  korean,
}

class Location {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final String zipCode;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  String get fullAddress => '$address, $city, $state $zipCode';
}

class EnhancedProfessionalResource {
  final String id;
  final String name;
  final String title; // Dr., LCSW, etc.
  final ProfessionalType type;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String bio;
  final List<String> specializations;
  final List<InsuranceType> acceptedInsurance;
  final List<TherapyType> therapyTypes;
  final List<Language> languages;
  final ServiceMode serviceMode;
  final Location? location;
  final String? phone;
  final String? email;
  final String? website;
  final String? bookingUrl;
  final double? priceRange; // Per session
  final bool isAvailable;
  final String? nextAvailability;
  final List<String> credentials;
  final int yearsExperience;

  EnhancedProfessionalResource({
    required this.id,
    required this.name,
    required this.title,
    required this.type,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.bio,
    required this.specializations,
    required this.acceptedInsurance,
    required this.therapyTypes,
    required this.languages,
    required this.serviceMode,
    this.location,
    this.phone,
    this.email,
    this.website,
    this.bookingUrl,
    this.priceRange,
    required this.isAvailable,
    this.nextAvailability,
    required this.credentials,
    required this.yearsExperience,
  });
}

// Extension methods for display
extension ProfessionalTypeExt on ProfessionalType {
  String get displayName {
    switch (this) {
      case ProfessionalType.therapist:
        return 'Licensed Therapist';
      case ProfessionalType.psychiatrist:
        return 'Psychiatrist';
      case ProfessionalType.counselor:
        return 'Counselor';
      case ProfessionalType.supportGroup:
        return 'Support Group';
      case ProfessionalType.crisisCenter:
        return 'Crisis Center';
      case ProfessionalType.wellnessCenter:
        return 'Wellness Center';
    }
  }

  String get emoji {
    switch (this) {
      case ProfessionalType.therapist:
        return '👩‍⚕️';
      case ProfessionalType.psychiatrist:
        return '🧠';
      case ProfessionalType.counselor:
        return '💬';
      case ProfessionalType.supportGroup:
        return '🤝';
      case ProfessionalType.crisisCenter:
        return '🆘';
      case ProfessionalType.wellnessCenter:
        return '🧘';
    }
  }
}

extension InsuranceTypeExt on InsuranceType {
  String get displayName {
    switch (this) {
      case InsuranceType.aetna:
        return 'Aetna';
      case InsuranceType.blueCross:
        return 'Blue Cross Blue Shield';
      case InsuranceType.cigna:
        return 'Cigna';
      case InsuranceType.unitedHealth:
        return 'UnitedHealth';
      case InsuranceType.medicare:
        return 'Medicare';
      case InsuranceType.medicaid:
        return 'Medicaid';
      case InsuranceType.outOfNetwork:
        return 'Out of Network';
      case InsuranceType.slidingScale:
        return 'Sliding Scale';
    }
  }
}

extension ServiceModeExt on ServiceMode {
  String get displayName {
    switch (this) {
      case ServiceMode.inPerson:
        return 'In-Person Only';
      case ServiceMode.telehealth:
        return 'Telehealth Only';
      case ServiceMode.both:
        return 'In-Person & Telehealth';
    }
  }

  String get emoji {
    switch (this) {
      case ServiceMode.inPerson:
        return '🏢';
      case ServiceMode.telehealth:
        return '💻';
      case ServiceMode.both:
        return '🔄';
    }
  }
}

extension LanguageExt on Language {
  String get displayName {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.spanish:
        return 'Español';
      case Language.french:
        return 'Français';
      case Language.mandarin:
        return '中文';
      case Language.arabic:
        return 'العربية';
      case Language.tagalog:
        return 'Tagalog';
      case Language.vietnamese:
        return 'Tiếng Việt';
      case Language.korean:
        return '한국어';
    }
  }
}