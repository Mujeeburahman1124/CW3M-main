import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import '../models/user_profile.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<UserProfile> {
  final ImagePicker _picker = ImagePicker();
  
  ProfileNotifier() : super(UserProfile(
    name: 'Athlete Name',
    profilePicture: '',
    memberSince: '2023',
  )) {
    _loadProfile();
  }

  static const String _boxName = 'settingsBox';
  static const String _key = 'userProfile';

  Future<void> _loadProfile() async {
    final box = Hive.box(_boxName);
    final firebaseUser = FirebaseAuth.instance.currentUser;
    
    if (firebaseUser != null) {
      try {
        // Fetch user data from Firestore
        log('Loading profile for user: ${firebaseUser.uid}');
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final userName = userData['name'] ?? firebaseUser.displayName ?? firebaseUser.email?.split('@')[0] ?? 'Athlete Name';
          final createdAt = userData['createdAt'] as Timestamp?;
          final memberSince = createdAt?.toDate().year.toString() ?? DateTime.now().year.toString();
          
          log('✅ Profile loaded from Firestore: $userName');
          
          // Get existing profile picture from local storage
          final localData = box.get(_key) as UserProfile?;
          final profilePicture = localData?.profilePicture ?? '';
          
          // Update state with Firestore data
          state = UserProfile(
            name: userName,
            profilePicture: profilePicture,
            memberSince: memberSince,
          );
          
          // Save to local storage
          await box.put(_key, state);
          return;
        } else {
          log('⚠️ User document not found in Firestore');
        }
      } catch (e) {
        log('⚠️ Error loading profile from Firestore: $e');
      }
    }
    
    // Fallback: Load from local storage or create default profile
    final data = box.get(_key);
    if (data != null) {
      state = data as UserProfile;
    } else {
      final userName = firebaseUser?.displayName ?? firebaseUser?.email?.split('@')[0] ?? 'Athlete Name';
      state = UserProfile(
        name: userName,
        profilePicture: '',
        memberSince: DateTime.now().year.toString(),
      );
    }
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    state = newProfile;
    final box = Hive.box(_boxName);
    await box.put(_key, newProfile);
    
    // Optional: Sync with Firebase if we want
    // await SyncService.saveProfile(newProfile); 
  }

  Future<void> reloadProfile() async {
    await _loadProfile();
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        // Store the local file path
        final updatedProfile = state.copyWith(profilePicture: image.path);
        await updateProfile(updatedProfile);
      }
    } catch (e) {
      // Handle error silently or throw
      rethrow;
    }
  }

  Future<void> takeSelfie() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        // Store the local file path
        final updatedProfile = state.copyWith(profilePicture: image.path);
        await updateProfile(updatedProfile);
      }
    } catch (e) {
      // Handle error silently or throw
      rethrow;
    }
  }
}
