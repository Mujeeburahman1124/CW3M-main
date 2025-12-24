import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/local/hive_service.dart';
import 'core/utils/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'firebase_options.dart';
import 'core/services/sync_service.dart';
import 'core/utils/data_seeder.dart';
import 'features/profile/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await HiveService.init();

  // Initialize Firebase with platform-specific options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log("✅ Firebase initialized successfully");

    // Initialize Firestore collections and seed data if needed
    await DataSeeder.initializeCollections();
    
    // Sync data from Firestore to Hive
    await SyncService.syncAll();
    log("✅ Data sync completed");
  } catch (e) {
    log("⚠️ Firebase initialization/sync failed: $e");
    log("💡 App will continue with local storage only");
    // App will continue but Firebase sync won't work
  }

  runApp(
    const ProviderScope(
      child: FitFlowApp(),
    ),
  );
}

class FitFlowApp extends ConsumerWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
      title: 'FitFlow Health & Fitness',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: authState.when(
        data: (user) {
          // If user is logged in, show dashboard, otherwise show login
          return user != null ? const DashboardScreen() : const LoginScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, __) => const LoginScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
