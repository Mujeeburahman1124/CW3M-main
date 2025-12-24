import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class AppSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String language;

  AppSettings({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.language,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? language,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings(
    isDarkMode: true,
    notificationsEnabled: true,
    language: 'English',
  )) {
    _loadSettings();
  }

  static const String _boxName = 'settingsBox';

  void _loadSettings() {
    final box = Hive.box(_boxName);
    state = AppSettings(
      isDarkMode: box.get('isDarkMode', defaultValue: true),
      notificationsEnabled: box.get('notificationsEnabled', defaultValue: true),
      language: box.get('language', defaultValue: 'English'),
    );
  }

  Future<void> toggleDarkMode(bool value) async {
    state = state.copyWith(isDarkMode: value);
    final box = Hive.box(_boxName);
    await box.put('isDarkMode', value);
  }

  Future<void> toggleNotifications(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    final box = Hive.box(_boxName);
    await box.put('notificationsEnabled', value);
  }

  Future<void> setLanguage(String value) async {
    state = state.copyWith(language: value);
    final box = Hive.box(_boxName);
    await box.put('language', value);
  }
}
