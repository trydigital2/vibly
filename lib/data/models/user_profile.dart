class UserProfile {
  final String id;
  final String name;
  final int age;
  final String bio;
  final String occupation;
  final String? company;
  final String? education;
  final String location;
  final double distanceKm;
  final List<String> photos;
  final List<String> interests;
  final Map<String, String> prompts;
  final String intention;
  final bool isVerified;
  final int compatibilityScore;
  final String? height;
  final String? zodiac;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.occupation,
    this.company,
    this.education,
    required this.location,
    required this.distanceKm,
    required this.photos,
    required this.interests,
    this.prompts = const {},
    required this.intention,
    this.isVerified = false,
    this.compatibilityScore = 85,
    this.height,
    this.zodiac,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? bio,
    String? occupation,
    String? company,
    String? education,
    String? location,
    double? distanceKm,
    List<String>? photos,
    List<String>? interests,
    Map<String, String>? prompts,
    String? intention,
    bool? isVerified,
    int? compatibilityScore,
    String? height,
    String? zodiac,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      occupation: occupation ?? this.occupation,
      company: company ?? this.company,
      education: education ?? this.education,
      location: location ?? this.location,
      distanceKm: distanceKm ?? this.distanceKm,
      photos: photos ?? this.photos,
      interests: interests ?? this.interests,
      prompts: prompts ?? this.prompts,
      intention: intention ?? this.intention,
      isVerified: isVerified ?? this.isVerified,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      height: height ?? this.height,
      zodiac: zodiac ?? this.zodiac,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'bio': bio,
      'occupation': occupation,
      'company': company,
      'education': education,
      'location': location,
      'distanceKm': distanceKm,
      'photos': photos,
      'interests': interests,
      'prompts': prompts,
      'intention': intention,
      'isVerified': isVerified,
      'compatibilityScore': compatibilityScore,
      'height': height,
      'zodiac': zodiac,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 24,
      bio: map['bio'] ?? '',
      occupation: map['occupation'] ?? '',
      company: map['company'],
      education: map['education'],
      location: map['location'] ?? 'Nearby',
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 3.0,
      photos: List<String>.from(map['photos'] ?? []),
      interests: List<String>.from(map['interests'] ?? []),
      prompts: Map<String, String>.from(map['prompts'] ?? {}),
      intention: map['intention'] ?? 'Long-term relationship',
      isVerified: map['isVerified'] ?? false,
      compatibilityScore: map['compatibilityScore']?.toInt() ?? 85,
      height: map['height'],
      zodiac: map['zodiac'],
    );
  }
}

