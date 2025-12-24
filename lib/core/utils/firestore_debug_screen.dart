import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

/// Debug screen to test Firestore connection
class FirestoreDebugScreen extends StatefulWidget {
  const FirestoreDebugScreen({super.key});

  @override
  State<FirestoreDebugScreen> createState() => _FirestoreDebugScreenState();
}

class _FirestoreDebugScreenState extends State<FirestoreDebugScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _status = 'Ready to test';
  bool _isLoading = false;

  Future<void> _testCreateUser() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating test user...';
    });

    try {
      final testUser = {
        'uid': 'debug_test_${DateTime.now().millisecondsSinceEpoch}',
        'email': 'debug@test.com',
        'name': 'Debug Test User',
        'createdAt': Timestamp.now(),
      };

      await _firestore
          .collection('users')
          .doc(testUser['uid'] as String)
          .set(testUser);

      setState(() {
        _status = '✅ SUCCESS! User created in Firestore.\nCheck Firebase Console → users collection';
        _isLoading = false;
      });

      log('Test user created successfully: ${testUser['uid']}');
    } catch (e) {
      setState(() {
        _status = '❌ ERROR: $e\n\nPossible issues:\n'
            '1. Firestore rules blocking writes\n'
            '2. API key not configured\n'
            '3. Internet connection issue';
        _isLoading = false;
      });

      log('Error creating test user: $e');
    }
  }

  Future<void> _testReadUsers() async {
    setState(() {
      _isLoading = true;
      _status = 'Reading users from Firestore...';
    });

    try {
      final snapshot = await _firestore.collection('users').limit(10).get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _status = '⚠️ Users collection exists but is empty.\n'
              'Try creating a test user first.';
          _isLoading = false;
        });
      } else {
        final usersList = snapshot.docs
            .map((doc) {
              final data = doc.data();
              return '  • ${data['name']} (${data['email']})';
            })
            .join('\n');

        setState(() {
          _status = '✅ Found ${snapshot.docs.length} users:\n\n$usersList';
          _isLoading = false;
        });
      }

      log('Read ${snapshot.docs.length} users from Firestore');
    } catch (e) {
      setState(() {
        _status = '❌ ERROR reading users: $e';
        _isLoading = false;
      });

      log('Error reading users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Debug'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🔍 Firestore Connection Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testCreateUser,
              icon: const Icon(Icons.add),
              label: const Text('Create Test User'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testReadUsers,
              icon: const Icon(Icons.search),
              label: const Text('Read Users from Firestore'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Expected Result:\n'
              '✅ User created successfully\n'
              '✅ Check Firebase Console → Firestore → users collection\n\n'
              'If you see errors, update Firestore rules in Firebase Console',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
