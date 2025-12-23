import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/local/hive_service.dart';
import 'core/utils/app_theme.dart';
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
    log("Firebase initialized successfully");

    // Seed initial data if needed
    await DataSeeder.seedData();
    
    // Sync data from Firestore to Hive
    await SyncService.syncAll();
  } catch (e) {
    log("Firebase initialization failed: $e");
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
    
    return MaterialApp(
      title: 'FitFlow Health & Fitness',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
