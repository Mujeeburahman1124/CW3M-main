import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      log('📝 Starting user registration for: $email');
      
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('✅ Firebase Auth user created: ${userCredential.user!.uid}');

      // Update display name
      await userCredential.user?.updateDisplayName(name);
      log('✅ Display name updated: $name');

      // Create user model
      UserModel userModel = UserModel.fromFirebaseUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      // Save user data to Firestore
      log('💾 Attempting to save user to Firestore...');
      log('   - UID: ${userCredential.user!.uid}');
      log('   - Email: $email');
      log('   - Name: $name');
      log('   - Data: ${userModel.toMap()}');
      
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap(), SetOptions(merge: true));
      
      log('✅ User data SAVED to Firestore successfully!');
      log('🔍 Verify at: Firebase Console > Firestore > users > ${userCredential.user!.uid}');
      
      return userModel;
    } on FirebaseAuthException catch (e) {
      log('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } on FirebaseException catch (e) {
      log('❌ Firestore Error: ${e.code} - ${e.message}');
      throw 'Failed to save user data: ${e.message}';
    } catch (e, stackTrace) {
      log('❌ Unexpected error during sign up: $e');
      log('Stack trace: $stackTrace');
      throw 'An error occurred during sign up: $e';
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      log('🔐 Starting user login for: $email');
      
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('✅ User authenticated: ${userCredential.user!.uid}');
      
      // Get user data from Firestore
      log('📖 Reading user data from Firestore...');
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        log('✅ User data found in Firestore');
        final userData = userDoc.data() as Map<String, dynamic>;
        log('   - Data: $userData');
        return UserModel.fromMap(userData);
      } else {
        // User exists in Auth but not in Firestore - create the document
        log('⚠️ User in Auth but not in Firestore. Creating user document...');
        UserModel userModel = UserModel.fromFirebaseUser(
          uid: userCredential.user!.uid,
          email: email,
          name: userCredential.user!.displayName ?? email.split('@')[0],
        );
        
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
        
        log('✅ User document created in Firestore');
        return userModel;
      }

    } on FirebaseAuthException catch (e) {
      log('❌ Firebase Auth Error during login: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } on FirebaseException catch (e) {
      log('❌ Firestore Error during login: ${e.code} - ${e.message}');
      throw 'Failed to read user data: ${e.message}';
    } catch (e, stackTrace) {
      log('❌ Unexpected error during sign in: $e');
      log('Stack trace: $stackTrace');
      throw 'An error occurred during sign in: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error signing out. Please try again.';
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Error fetching user data.';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Error sending password reset email.';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An authentication error occurred: ${e.message}';
    }
  }
}
