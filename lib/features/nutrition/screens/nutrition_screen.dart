import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/app_theme.dart';
import '../providers/nutrition_provider.dart';
import 'add_meal_screen.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(isDark),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text('Nutrition Tracker'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: meals.isEmpty
                ? Center(
                    child: Text(
                      'No meals tracked today.',
                      style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return Dismissible(
                        key: Key(meal.id),
                        onDismissed: (_) {
                          ref.read(mealListProvider.notifier).deleteMeal(meal.id);
                        },
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddMealScreen(meal: meal),
                              ),
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.restaurant_rounded, color: Color(0xFF06B6D4), size: 20),
                            ),
                            title: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${meal.calories} kcal • P:${meal.protein}g C:${meal.carbs}g F:${meal.fat}g'),
                            trailing: const Icon(Icons.chevron_right_rounded, color: Colors.blueGrey, size: 20),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddMealScreen()),
        ),
        backgroundColor: const Color(0xFF06B6D4),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
