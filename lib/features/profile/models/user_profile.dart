import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String profilePicture;

  @HiveField(2)
  final String memberSince;

  UserProfile({
    required this.name,
    required this.profilePicture,
    required this.memberSince,
  });

  UserProfile copyWith({
    String? name,
    String? profilePicture,
    String? memberSince,
  }) {
    return UserProfile(
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      memberSince: memberSince ?? this.memberSince,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'profilePicture': profilePicture,
    'memberSince': memberSince,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] ?? 'Athlete Name',
    profilePicture: json['profilePicture'] ?? 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&q=80',
    memberSince: json['memberSince'] ?? '2023',
  );
}
