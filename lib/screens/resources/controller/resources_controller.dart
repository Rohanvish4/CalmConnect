import 'package:get/get.dart';
import '../../../model/enhanced_professional_resource.dart';

enum SortOption {
  rating,
  distance,
  price,
  availability,
  experience,
}

class ResourceFilter {
  final ProfessionalType? type;
  final List<InsuranceType>? insurance;
  final List<TherapyType>? therapyTypes;
  final List<Language>? languages;
  final ServiceMode? serviceMode;
  final double? maxDistance; // in miles (not applied yet)
  final double? maxPrice;
  final bool? availableOnly;

  const ResourceFilter({
    this.type,
    this.insurance,
    this.therapyTypes,
    this.languages,
    this.serviceMode,
    this.maxDistance,
    this.maxPrice,
    this.availableOnly,
  });

  ResourceFilter copyWith({
    ProfessionalType? type,
    List<InsuranceType>? insurance,
    List<TherapyType>? therapyTypes,
    List<Language>? languages,
    ServiceMode? serviceMode,
    double? maxDistance,
    double? maxPrice,
    bool? availableOnly,
  }) {
    return ResourceFilter(
      type: type ?? this.type,
      insurance: insurance ?? this.insurance,
      therapyTypes: therapyTypes ?? this.therapyTypes,
      languages: languages ?? this.languages,
      serviceMode: serviceMode ?? this.serviceMode,
      maxDistance: maxDistance ?? this.maxDistance,
      maxPrice: maxPrice ?? this.maxPrice,
      availableOnly: availableOnly ?? this.availableOnly,
    );
  }
}

class ResourcesController extends GetxController {
  List<EnhancedProfessionalResource> _allResources = [];
  List<EnhancedProfessionalResource> _filteredResources = [];
  String _searchQuery = '';
  ResourceFilter _activeFilter = const ResourceFilter();
  SortOption _sortOption = SortOption.rating;
  bool _isLoading = false;
  List<EnhancedProfessionalResource> _favorites = [];

  // Getters
  List<EnhancedProfessionalResource> get resources => _filteredResources;
  List<EnhancedProfessionalResource> get favorites => _favorites;
  String get searchQuery => _searchQuery;
  ResourceFilter get activeFilter => _activeFilter;
  SortOption get sortOption => _sortOption;
  bool get isLoading => _isLoading;

  @override
  void onReady() {
    super.onReady();
    loadResources();
  }

  void loadResources() {
    _isLoading = true;
    update();

    _allResources = generateMockProfessionals();
    _applyFiltersAndSort();

    _isLoading = false;
    update();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSort();
    update();
  }

  void updateFilter(ResourceFilter filter) {
    _activeFilter = filter;
    _applyFiltersAndSort();
    update();
  }

  void updateSort(SortOption option) {
    _sortOption = option;
    _applyFiltersAndSort();
    update();
  }

  void toggleFavorite(String resourceId) {
    final idx = _allResources.indexWhere((r) => r.id == resourceId);
    if (idx == -1) return;
    final resource = _allResources[idx];

    final favIdx = _favorites.indexWhere((r) => r.id == resourceId);
    if (favIdx != -1) {
      _favorites.removeAt(favIdx);
    } else {
      _favorites.add(resource);
    }
    update();
  }

  bool isFavorite(String resourceId) {
    return _favorites.any((r) => r.id == resourceId);
  }

  void clearFilters() {
    _activeFilter = const ResourceFilter();
    _searchQuery = '';
    _applyFiltersAndSort();
    update();
  }

  void _applyFiltersAndSort() {
    var filtered = List<EnhancedProfessionalResource>.from(_allResources);

    // Search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((resource) {
        final q = _searchQuery;
        return resource.name.toLowerCase().contains(q) ||
            resource.title.toLowerCase().contains(q) ||
            resource.bio.toLowerCase().contains(q) ||
            resource.specializations.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }

    // Filters
    if (_activeFilter.type != null) {
      filtered = filtered.where((r) => r.type == _activeFilter.type).toList();
    }

    if (_activeFilter.insurance != null && _activeFilter.insurance!.isNotEmpty) {
      filtered = filtered.where((r) {
        return _activeFilter.insurance!.any((ins) => r.acceptedInsurance.contains(ins));
      }).toList();
    }

    if (_activeFilter.therapyTypes != null && _activeFilter.therapyTypes!.isNotEmpty) {
      filtered = filtered.where((r) {
        return _activeFilter.therapyTypes!.any((t) => r.therapyTypes.contains(t));
      }).toList();
    }

    if (_activeFilter.languages != null && _activeFilter.languages!.isNotEmpty) {
      filtered = filtered.where((r) {
        return _activeFilter.languages!.any((lang) => r.languages.contains(lang));
      }).toList();
    }

    if (_activeFilter.serviceMode != null) {
      filtered = filtered.where((r) {
        return r.serviceMode == _activeFilter.serviceMode || r.serviceMode == ServiceMode.both;
      }).toList();
    }

    if (_activeFilter.maxPrice != null) {
      filtered = filtered.where((r) => r.priceRange != null && r.priceRange! <= _activeFilter.maxPrice!).toList();
    }

    if (_activeFilter.availableOnly == true) {
      filtered = filtered.where((r) => r.isAvailable).toList();
    }

    // Sorting
    switch (_sortOption) {
      case SortOption.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.distance:
        // Placeholder: replace with actual distance calc
        filtered.shuffle();
        break;
      case SortOption.price:
        filtered.sort((a, b) {
          if (a.priceRange == null && b.priceRange == null) return 0;
          if (a.priceRange == null) return 1;
          if (b.priceRange == null) return -1;
          return a.priceRange!.compareTo(b.priceRange!);
        });
        break;
      case SortOption.availability:
        filtered.sort((a, b) {
          if (a.isAvailable && !b.isAvailable) return -1;
          if (!a.isAvailable && b.isAvailable) return 1;
          return 0;
        });
        break;
      case SortOption.experience:
        filtered.sort((a, b) => b.yearsExperience.compareTo(a.yearsExperience));
        break;
    }

    _filteredResources = filtered;
  }

  // Clean, de-duplicated, and valid mock data
  List<EnhancedProfessionalResource> generateMockProfessionals() {
    return [
      // India-based professionals
      EnhancedProfessionalResource(
        id: 'prof_009',
        name: 'Dr. Radhika Mehra',
        title: 'Clinical Psychologist',
        type: ProfessionalType.therapist,
        imageUrl: 'https://unsplash.com/photos/a-woman-in-a-white-coat-H9lg5Noj660',
        rating: 4.8,
        reviews: 110,
        bio: 'Expert in CBT and trauma recovery, 12+ years experience in Delhi.',
        specializations: ['CBT', 'Trauma', 'Depression'],
        acceptedInsurance: [InsuranceType.blueCross],
        therapyTypes: [TherapyType.cbt],
        languages: [Language.english],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 28.6139,
          longitude: 77.2090,
          city: 'Delhi',
          state: 'Delhi',
          address: 'A-12, Connaught Place',
          zipCode: '110001',
        ),
        phone: '(011) 2345-6789',
        email: 'radhika.mehra@therapy.in',
        priceRange: 150.0,
        isAvailable: true,
        nextAvailability: 'Tomorrow',
        credentials: ['PhD Clinical Psychology'],
        yearsExperience: 12,
      ),
      EnhancedProfessionalResource(
        id: 'prof_010',
        name: 'Dr. Sriya Iyer',
        title: 'Counsellor',
        type: ProfessionalType.counselor,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-Rnh_X2p8_-T3mzgnf0U60-4ID4SpDx6jhA&s',
        rating: 4.7,
        reviews: 98,
        bio: 'Family and relationship counselling, 10+ years in Mumbai.',
        specializations: ['Family', 'Relationships', 'Communication'],
        acceptedInsurance: [InsuranceType.aetna],
        therapyTypes: [TherapyType.familyTherapy],
        languages: [Language.english],
        serviceMode: ServiceMode.inPerson,
        location: Location(
          latitude: 19.0760,
          longitude: 72.8777,
          city: 'Mumbai',
          state: 'MH',
          address: 'B-22, Bandra',
          zipCode: '400050',
        ),
        phone: '(022) 3456-7890',
        email: 'suresh.iyer@counsel.in',
        priceRange: 120.0,
        isAvailable: true,
        nextAvailability: 'Next week',
        credentials: ['MA Counselling'],
        yearsExperience: 10,
      ),
      EnhancedProfessionalResource(
        id: 'prof_011',
        name: 'Dr. Anjali Rao',
        title: 'Child Psychologist',
        type: ProfessionalType.therapist,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBb5u9habfcx7EWoU5Nd6FpypJc83iN8gsQA&s',
        rating: 4.9,
        reviews: 120,
        bio: 'Specialist in child and adolescent therapy, Bangalore.',
        specializations: ['Child Therapy', 'Adolescents', 'Anxiety'],
        acceptedInsurance: [InsuranceType.unitedHealth],
        therapyTypes: [TherapyType.cbt],
        languages: [Language.english],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 12.9716,
          longitude: 77.5946,
          city: 'Bangalore',
          state: 'KA',
          address: 'C-34, Indiranagar',
          zipCode: '560038',
        ),
        phone: '(080) 4567-8901',
        email: 'anjali.rao@childpsych.in',
        priceRange: 180.0,
        isAvailable: true,
        nextAvailability: 'Friday',
        credentials: ['PhD Child Psychology'],
        yearsExperience: 14,
      ),
      EnhancedProfessionalResource(
        id: 'prof_012',
        name: 'Dr. Amitabh Singh',
        title: 'Marriage Counsellor',
        type: ProfessionalType.counselor,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_EZpinLhocwrg1_BJFpsVU9IsNToqdhwK9w&s',
        rating: 4.6,
        reviews: 85,
        bio: 'Marriage and couples therapy, 8+ years in Lucknow.',
        specializations: ['Marriage', 'Couples', 'Conflict Resolution'],
        acceptedInsurance: [InsuranceType.cigna],
        therapyTypes: [TherapyType.humanistic],
        languages: [Language.english],
        serviceMode: ServiceMode.inPerson,
        location: Location(
          latitude: 26.8467,
          longitude: 80.9462,
          city: 'Lucknow',
          state: 'UP',
          address: 'D-56, Hazratganj',
          zipCode: '226001',
        ),
        phone: '(0522) 5678-9012',
        email: 'amitabh.singh@marriagehelp.in',
        priceRange: 130.0,
        isAvailable: true,
        nextAvailability: 'Monday',
        credentials: ['MA Marriage Counselling'],
        yearsExperience: 8,
      ),
      EnhancedProfessionalResource(
        id: 'prof_013',
        name: 'Dr. Priya Nair',
        title: 'Clinical Therapist',
        type: ProfessionalType.therapist,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgUJ5xyWeWtRwvqvyzuLbzSfLo1wjuAPMo_Q&s',
        rating: 4.7,
        reviews: 105,
        bio: 'CBT and mindfulness expert, 11+ years in Kochi.',
        specializations: ['CBT', 'Mindfulness', 'Stress'],
        acceptedInsurance: [InsuranceType.blueCross],
        therapyTypes: [TherapyType.mindfulness],
        languages: [Language.english],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 9.9312,
          longitude: 76.2673,
          city: 'Kochi',
          state: 'KL',
          address: 'E-78, MG Road',
          zipCode: '682016',
        ),
        phone: '(0484) 6789-0123',
        email: 'priya.nair@therapykochi.in',
        priceRange: 140.0,
        isAvailable: true,
        nextAvailability: 'Wednesday',
        credentials: ['PhD Clinical Therapy'],
        yearsExperience: 11,
      ),
      EnhancedProfessionalResource(
        id: 'prof_014',
        name: 'Dr. Manish Verma',
        title: 'Psychiatric Counsellor',
        type: ProfessionalType.counselor,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDegSnM1BupqlLkwOfnzKYPM7Hdkl3nvtmQw&s',
        rating: 4.5,
        reviews: 90,
        bio: 'Psychiatric counselling and support, 9+ years in Jaipur.',
        specializations: ['Psychiatric', 'Support', 'Anxiety'],
        acceptedInsurance: [InsuranceType.aetna],
        therapyTypes: [TherapyType.cbt],
        languages: [Language.english],
        serviceMode: ServiceMode.inPerson,
        location: Location(
          latitude: 26.9124,
          longitude: 75.7873,
          city: 'Jaipur',
          state: 'RJ',
          address: 'F-90, C-Scheme',
          zipCode: '302001',
        ),
        phone: '(0141) 7890-1234',
        email: 'manish.verma@jaipurcounsel.in',
        priceRange: 125.0,
        isAvailable: true,
        nextAvailability: 'Thursday',
        credentials: ['MA Psychiatric Counselling'],
        yearsExperience: 9,
      ),
      EnhancedProfessionalResource(
        id: 'prof_015',
        name: 'Dr. Sneha Kulkarni',
        title: 'Therapist',
        type: ProfessionalType.therapist,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_RT1Bdp6yfow-0BjMs612nxYYAf9BCUHMvA&s',
        rating: 4.8,
        reviews: 115,
        bio: 'Therapist for stress and anxiety, 13+ years in Pune.',
        specializations: ['Stress', 'Anxiety', 'CBT'],
        acceptedInsurance: [InsuranceType.cigna],
        therapyTypes: [TherapyType.cbt],
        languages: [Language.english],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 18.5204,
          longitude: 73.8567,
          city: 'Pune',
          state: 'MH',
          address: 'G-12, Koregaon Park',
          zipCode: '411001',
        ),
        phone: '(020) 8901-2345',
        email: 'sneha.kulkarni@punehelp.in',
        priceRange: 160.0,
        isAvailable: true,
        nextAvailability: 'Saturday',
        credentials: ['PhD Therapy'],
        yearsExperience: 13,
      ),
      EnhancedProfessionalResource(
        id: 'prof_016',
        name: 'Dr. Arvind Joshi',
        title: 'Mental Health Counsellor',
        type: ProfessionalType.counselor,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKBn7udw3mJvX4Rs197xb1le3UlyVI31KwMQ&s',
        rating: 4.6,
        reviews: 100,
        bio: 'Mental health counselling, 10+ years in Ahmedabad.',
        specializations: ['Mental Health', 'CBT', 'Support'],
        acceptedInsurance: [InsuranceType.unitedHealth],
        therapyTypes: [TherapyType.cbt],
        languages: [Language.english],
        serviceMode: ServiceMode.inPerson,
        location: Location(
          latitude: 23.0225,
          longitude: 72.5714,
          city: 'Ahmedabad',
          state: 'GJ',
          address: 'H-45, Navrangpura',
          zipCode: '380009',
        ),
        phone: '(079) 9012-3456',
        email: 'arvind.joshi@ahmedabadcounsel.in',
        priceRange: 135.0,
        isAvailable: true,
        nextAvailability: 'Sunday',
        credentials: ['MA Mental Health'],
        yearsExperience: 10,
      ),
      EnhancedProfessionalResource(
        id: 'prof_017',
        name: 'Dr. Kavita Pillai',
        title: 'Therapist',
        type: ProfessionalType.therapist,
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRi-8wAgxfSFcX7nriBakBWs7pBseF802QGQg&s',
        rating: 4.7,
        reviews: 108,
        bio: 'Therapist for women\'s issues and trauma, 12+ years in Chennai.',
        specializations: ['Women', 'Trauma', 'CBT'],
        acceptedInsurance: [InsuranceType.blueCross],
        therapyTypes: [TherapyType.cbt],
        languages: [Language.english],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 13.0827,
          longitude: 80.2707,
          city: 'Chennai',
          state: 'TN',
          address: 'J-23, T Nagar',
          zipCode: '600017',
        ),
        phone: '(044) 2345-6789',
        email: 'kavita.pillai@chennaitherapy.in',
        priceRange: 145.0,
        isAvailable: true,
        nextAvailability: 'Tuesday',
        credentials: ['PhD Therapy'],
        yearsExperience: 12,
      ),

      // US-based practitioners and centers
      EnhancedProfessionalResource(
        id: 'prof_001',
        name: 'Dr. Sarah Johnson',
        title: 'LCSW, PhD',
        type: ProfessionalType.therapist,
        imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
        rating: 4.9,
        reviews: 127,
        bio:
            'Specializing in anxiety, depression, and trauma recovery with 15+ years of experience. I use evidence-based approaches including CBT and EMDR to help clients achieve lasting change.',
        specializations: ['Anxiety Disorders', 'Depression', 'PTSD', 'Women\'s Issues'],
        acceptedInsurance: [InsuranceType.blueCross, InsuranceType.aetna, InsuranceType.unitedHealth],
        therapyTypes: [TherapyType.cbt, TherapyType.emdr, TherapyType.mindfulness],
        languages: [Language.english, Language.spanish],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 40.7128,
          longitude: -74.0060,
          address: '123 Main St, Suite 400',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
        ),
        phone: '(555) 123-4567',
        email: 'dr.johnson@therapy.com',
        website: 'https://drsarahjohnson.com',
        bookingUrl: 'https://calendly.com/dr-johnson',
        priceRange: 150.0,
        isAvailable: true,
        nextAvailability: 'Tomorrow at 2:00 PM',
        credentials: ['PhD Psychology', 'Licensed Clinical Social Worker', 'EMDR Certified'],
        yearsExperience: 15,
      ),
      EnhancedProfessionalResource(
        id: 'prof_002',
        name: 'Dr. Michael Chen',
        title: 'MD, Psychiatrist',
        type: ProfessionalType.psychiatrist,
        imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
        rating: 4.8,
        reviews: 93,
        bio:
            'Board-certified psychiatrist specializing in medication management for mood disorders, ADHD, and anxiety. I work collaboratively with therapists to provide comprehensive care.',
        specializations: ['Bipolar Disorder', 'ADHD', 'Major Depression', 'Anxiety Disorders'],
        acceptedInsurance: [InsuranceType.cigna, InsuranceType.medicare, InsuranceType.blueCross],
        therapyTypes: [TherapyType.psychodynamic],
        languages: [Language.english, Language.mandarin],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 40.7589,
          longitude: -73.9851,
          address: '456 Park Ave, Floor 12',
          city: 'New York',
          state: 'NY',
          zipCode: '10016',
        ),
        phone: '(555) 234-5678',
        email: 'dr.chen@psychiatry.org',
        priceRange: 200.0,
        isAvailable: true,
        nextAvailability: 'Next week',
        credentials: ['MD Psychiatry', 'Board Certified', 'Columbia University'],
        yearsExperience: 12,
      ),
      EnhancedProfessionalResource(
        id: 'prof_003',
        name: 'Maria Rodriguez',
        title: 'LMFT',
        type: ProfessionalType.counselor,
        imageUrl: 'https://images.unsplash.com/photo-1607990281513-2c110a25bd8c?w=400',
        rating: 4.7,
        reviews: 156,
        bio:
            'Licensed Marriage and Family Therapist with expertise in couples counseling, family dynamics, and relationship issues. Bilingual services available.',
        specializations: ['Couples Therapy', 'Family Counseling', 'Relationship Issues', 'Communication'],
        acceptedInsurance: [InsuranceType.slidingScale, InsuranceType.medicaid, InsuranceType.aetna],
        therapyTypes: [TherapyType.familyTherapy, TherapyType.humanistic],
        languages: [Language.english, Language.spanish],
        serviceMode: ServiceMode.inPerson,
        location: Location(
          latitude: 34.0522,
          longitude: -118.2437,
          address: '789 Sunset Blvd, Suite 200',
          city: 'Los Angeles',
          state: 'CA',
          zipCode: '90028',
        ),
        phone: '(555) 345-6789',
        email: 'maria@familycare.com',
        priceRange: 120.0,
        isAvailable: false,
        nextAvailability: 'In 2 weeks',
        credentials: ['LMFT Licensed', 'Gottman Method Certified', 'UCLA Graduate'],
        yearsExperience: 8,
      ),
      EnhancedProfessionalResource(
        id: 'prof_004',
        name: 'Anxiety Support Circle',
        title: 'Weekly Support Group',
        type: ProfessionalType.supportGroup,
        imageUrl: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400',
        rating: 4.6,
        reviews: 89,
        bio:
            'Peer-led support group for individuals dealing with anxiety disorders. Meet weekly in a safe, supportive environment to share experiences and coping strategies.',
        specializations: ['Anxiety Disorders', 'Panic Attacks', 'Social Anxiety', 'Peer Support'],
        acceptedInsurance: [InsuranceType.outOfNetwork],
        therapyTypes: [TherapyType.groupTherapy, TherapyType.mindfulness],
        languages: [Language.english],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 41.8781,
          longitude: -87.6298,
          address: '321 Community Center Dr',
          city: 'Chicago',
          state: 'IL',
          zipCode: '60601',
        ),
        phone: '(555) 456-7890',
        email: 'info@anxietycircle.org',
        priceRange: 25.0,
        isAvailable: true,
        nextAvailability: 'Thursdays at 7:00 PM',
        credentials: ['Peer-Led', 'NAMI Certified', 'Community Based'],
        yearsExperience: 5,
      ),
      EnhancedProfessionalResource(
        id: 'prof_005',
        name: 'Crisis Intervention Center',
        title: '24/7 Emergency Support',
        type: ProfessionalType.crisisCenter,
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        rating: 4.9,
        reviews: 234,
        bio:
            'Round-the-clock crisis intervention services with trained mental health professionals. Walk-in availability and emergency response team.',
        specializations: ['Crisis Intervention', 'Suicide Prevention', 'Emergency Care', 'Safety Planning'],
        acceptedInsurance: [InsuranceType.medicare, InsuranceType.medicaid, InsuranceType.slidingScale],
        therapyTypes: [TherapyType.cbt],
        languages: [Language.english, Language.spanish, Language.arabic],
        serviceMode: ServiceMode.inPerson,
        location: Location(
          latitude: 39.7392,
          longitude: -104.9903,
          address: '555 Emergency Blvd',
          city: 'Denver',
          state: 'CO',
          zipCode: '80202',
        ),
        phone: '(555) 911-HELP',
        email: 'crisis@denverhelp.org',
        priceRange: 0.0,
        isAvailable: true,
        nextAvailability: 'Available 24/7',
        credentials: ['State Licensed', 'SAMHSA Certified', '24/7 Operations'],
        yearsExperience: 20,
      ),
      EnhancedProfessionalResource(
        id: 'prof_006',
        name: 'Mindful Living Wellness',
        title: 'Holistic Wellness Center',
        type: ProfessionalType.wellnessCenter,
        imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400',
        rating: 4.5,
        reviews: 178,
        bio:
            'Integrative wellness center offering meditation, yoga therapy, art therapy, and mindfulness-based stress reduction programs for mental health.',
        specializations: ['Mindfulness', 'Stress Reduction', 'Meditation', 'Holistic Health'],
        acceptedInsurance: [InsuranceType.outOfNetwork, InsuranceType.slidingScale],
        therapyTypes: [TherapyType.mindfulness, TherapyType.artTherapy],
        languages: [Language.english, Language.korean, Language.vietnamese],
        serviceMode: ServiceMode.both,
        location: Location(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '888 Peaceful Way',
          city: 'San Francisco',
          state: 'CA',
          zipCode: '94102',
        ),
        phone: '(555) 567-8901',
        email: 'hello@mindfullivingwellness.com',
        website: 'https://mindfullivingwellness.com',
        priceRange: 80.0,
        isAvailable: true,
        nextAvailability: 'Daily classes available',
        credentials: ['Certified Wellness Center', 'Licensed Therapists', 'Yoga Alliance'],
        yearsExperience: 7,
      ),
      EnhancedProfessionalResource(
        id: 'prof_007',
        name: 'Dr. Emily Watson',
        title: 'LPC, EMDR Specialist',
        type: ProfessionalType.therapist,
        imageUrl: 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400',
        rating: 4.8,
        reviews: 142,
        bio:
            'Trauma-informed therapist specializing in EMDR, childhood trauma, and attachment issues. Creating a safe space for healing and growth.',
        specializations: ['Trauma Recovery', 'EMDR', 'Attachment Issues', 'Childhood Trauma'],
        acceptedInsurance: [InsuranceType.unitedHealth, InsuranceType.cigna],
        therapyTypes: [TherapyType.emdr, TherapyType.cbt, TherapyType.psychodynamic],
        languages: [Language.english],
        serviceMode: ServiceMode.telehealth,
        phone: '(555) 678-9012',
        email: 'dr.watson@traumahealing.com',
        priceRange: 175.0,
        isAvailable: true,
        nextAvailability: 'This week',
        credentials: ['LPC Licensed', 'EMDR International Association', 'Trauma Specialist'],
        yearsExperience: 10,
      ),
      EnhancedProfessionalResource(
        id: 'prof_008',
        name: 'Teen Mental Health Group',
        title: 'Adolescent Support Program',
        type: ProfessionalType.supportGroup,
        imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
        rating: 4.7,
        reviews: 95,
        bio:
            'Specialized support groups for teenagers dealing with depression, anxiety, and social challenges. Age-appropriate therapy in group setting.',
        specializations: ['Teen Depression', 'Social Anxiety', 'Peer Issues', 'School Stress'],
        acceptedInsurance: [InsuranceType.medicaid, InsuranceType.slidingScale],
        therapyTypes: [TherapyType.groupTherapy, TherapyType.dbt],
        languages: [Language.english, Language.spanish],
        serviceMode: ServiceMode.inPerson,
        location: Location(
          latitude: 30.2672,
          longitude: -97.7431,
          address: '123 Youth Center Ave',
          city: 'Austin',
          state: 'TX',
          zipCode: '78701',
        ),
        phone: '(555) 789-0123',
        priceRange: 40.0,
        isAvailable: true,
        nextAvailability: 'Tuesdays & Thursdays',
        credentials: ['Licensed Teen Program', 'DBT Certified', 'Youth Specialists'],
        yearsExperience: 6,
      ),
    ];
  }
}