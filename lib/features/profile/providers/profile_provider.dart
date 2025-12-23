import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../../../core/services/sync_service.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(UserProfile(
    name: 'Athlete Name',
    profilePicture: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&q=80',
    memberSince: '2023',
  )) {
    _loadProfile();
  }

  static const String _boxName = 'settingsBox';
  static const String _key = 'userProfile';

  void _loadProfile() {
    final box = Hive.box(_boxName);
    final data = box.get(_key);
    if (data != null) {
      state = data as UserProfile;
    }
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    state = newProfile;
    final box = Hive.box(_boxName);
    await box.put(_key, newProfile);
    
    // Optional: Sync with Firebase if we want
    // await SyncService.saveProfile(newProfile); 
  }
}
