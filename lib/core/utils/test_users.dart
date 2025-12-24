import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

/// Test utility to create sample user data in Firestore
/// Run this once to verify Firestore connection and users collection
class FirestoreTestUsers {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create test users in Firestore to verify database is working
  static Future<void> createTestUsers() async {
    try {
      log('🧪 Creating test users in Firestore...');

      // Test User 1
      final testUser1 = {
        'uid': 'test_user_001',
        'email': 'john.doe@example.com',
        'name': 'John Doe',
        'photoUrl': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&q=80',
        'createdAt': Timestamp.now(),
      };

      await _firestore
          .collection('users')
          .doc('test_user_001')
          .set(testUser1, SetOptions(merge: true));
      
      log('✅ Test User 1 created: John Doe');

      // Test User 2
      final testUser2 = {
        'uid': 'test_user_002',
        'email': 'jane.smith@example.com',
        'name': 'Jane Smith',
        'photoUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80',
        'createdAt': Timestamp.now(),
      };

      await _firestore
          .collection('users')
          .doc('test_user_002')
          .set(testUser2, SetOptions(merge: true));
      
      log('✅ Test User 2 created: Jane Smith');

      // Test User 3
      final testUser3 = {
        'uid': 'test_user_003',
        'email': 'athlete.pro@fitness.com',
        'name': 'Alex Fitness',
        'photoUrl': 'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=400&q=80',
        'createdAt': Timestamp.now(),
      };

      await _firestore
          .collection('users')
          .doc('test_user_003')
          .set(testUser3, SetOptions(merge: true));
      
      log('✅ Test User 3 created: Alex Fitness');

      log('🎉 All test users created successfully!');
      log('📊 Check Firebase Console → Firestore → users collection');
      
    } catch (e) {
      log('❌ Error creating test users: $e');
      log('💡 Make sure Firestore rules allow writes and API key is correct');
    }
  }

  /// Verify users collection exists and can be read
  static Future<void> verifyUsersCollection() async {
    try {
      log('🔍 Verifying users collection...');
      
      final snapshot = await _firestore.collection('users').limit(5).get();
      
      if (snapshot.docs.isEmpty) {
        log('⚠️ Users collection is empty');
      } else {
        log('✅ Found ${snapshot.docs.length} users in Firestore:');
        for (var doc in snapshot.docs) {
          final data = doc.data();
          log('   - ${data['name']} (${data['email']})');
        }
      }
    } catch (e) {
      log('❌ Error reading users collection: $e');
    }
  }

  /// Delete all test users (cleanup)
  static Future<void> deleteTestUsers() async {
    try {
      log('🗑️ Deleting test users...');
      
      await _firestore.collection('users').doc('test_user_001').delete();
      await _firestore.collection('users').doc('test_user_002').delete();
      await _firestore.collection('users').doc('test_user_003').delete();
      
      log('✅ Test users deleted');
    } catch (e) {
      log('❌ Error deleting test users: $e');
    }
  }
}
