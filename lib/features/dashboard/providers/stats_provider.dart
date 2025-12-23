import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../workout/providers/workout_provider.dart';
import '../../nutrition/providers/nutrition_provider.dart';

final streakProvider = Provider<int>((ref) {
  final workouts = ref.watch(workoutListProvider);
  final meals = ref.watch(mealListProvider);

  if (workouts.isEmpty && meals.isEmpty) return 0;

  // Combine all activity dates
  final activityDates = {
    ...workouts.map((w) => DateTime(w.date.year, w.date.month, w.date.day)),
    ...meals.map((m) => DateTime(m.date.year, m.date.month, m.date.day)),
  }.toList();

  if (activityDates.isEmpty) return 0;

  // Sort dates descending
  activityDates.sort((a, b) => b.compareTo(a));

  final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final yesterday = today.subtract(const Duration(days: 1));

  // If no activity today and no activity yesterday, streak is broken
  if (!activityDates.contains(today) && !activityDates.contains(yesterday)) {
    return 0;
  }

  int streak = 0;
  DateTime currentDay = activityDates.contains(today) ? today : yesterday;

  while (activityDates.contains(currentDay)) {
    streak++;
    currentDay = currentDay.subtract(const Duration(days: 1));
  }

  return streak;
});
