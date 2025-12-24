import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_model.dart';
import '../../../core/services/sync_service.dart';

final workoutListProvider = StateNotifierProvider<WorkoutNotifier, List<WorkoutModel>>((ref) {
  return WorkoutNotifier();
});

class WorkoutNotifier extends StateNotifier<List<WorkoutModel>> {
  WorkoutNotifier() : super([]) {
    _init();
  }

  final _box = Hive.box<WorkoutModel>('workoutsBox');

  void _init() {
    _loadWorkouts();
    // Listen for box changes to keep UI in sync
    _box.listenable().addListener(_loadWorkouts);
  }

  void _loadWorkouts() {
    state = _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    await SyncService.saveWorkout(workout);
    _loadWorkouts();
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    await SyncService.saveWorkout(workout);
    _loadWorkouts();
  }

  Future<void> deleteWorkout(String id) async {
    await SyncService.deleteWorkout(id);
    _loadWorkouts();
  }

  // Force sync from Firestore
  Future<void> syncFromFirestore() async {
    await SyncService.syncWorkouts();
    _loadWorkouts();
  }
}
