import 'package:hive_flutter/hive_flutter.dart';
import '../../features/workout/models/workout_model.dart';
import '../../features/nutrition/models/meal_model.dart';
import '../../features/profile/models/user_profile.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(WorkoutModelAdapter());
    Hive.registerAdapter(MealModelAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    // Open Boxes
    await Hive.openBox<WorkoutModel>('workoutsBox');
    await Hive.openBox<MealModel>('mealsBox');
    await Hive.openBox('settingsBox');
  }
}
