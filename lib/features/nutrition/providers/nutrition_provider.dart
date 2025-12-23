import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/meal_model.dart';
import '../../../core/services/sync_service.dart';

final mealListProvider = StateNotifierProvider<MealNotifier, List<MealModel>>((ref) {
  return MealNotifier();
});

class MealNotifier extends StateNotifier<List<MealModel>> {
  MealNotifier() : super([]) {
    _init();
  }

  final _box = Hive.box<MealModel>('mealsBox');

  void _init() {
    _loadMeals();
    // Listen for box changes to keep UI in sync
    _box.listenable().addListener(_loadMeals);
  }

  void _loadMeals() {
    state = _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addMeal(MealModel meal) async {
    await SyncService.saveMeal(meal);
    _loadMeals();
  }

  Future<void> updateMeal(MealModel meal) async {
    await SyncService.saveMeal(meal);
    _loadMeals();
  }

  Future<void> deleteMeal(String id) async {
    await SyncService.deleteMeal(id);
    _loadMeals();
  }
}
