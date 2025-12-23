import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitflow_fitness_assistant/core/utils/app_theme.dart';
import '../../workout/providers/workout_provider.dart';
import '../../workout/models/workout_model.dart';
import '../../nutrition/providers/nutrition_provider.dart';
import '../../nutrition/models/meal_model.dart';

class ActivityHistoryScreen extends ConsumerWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutListProvider);
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
              title: Text('Activity History', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: const Color(0xFF6366F1),
                      unselectedLabelColor: isDark ? Colors.white60 : Colors.grey[600],
                      indicatorColor: const Color(0xFF6366F1),
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: const [
                        Tab(text: 'Workouts'),
                        Tab(text: 'Meals'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildWorkoutTab(context, workouts),
                          _buildMealTab(context, meals),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTab(BuildContext context, List workouts) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        if (workouts.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildTrendChart(workouts, const Color(0xFF6366F1), isDark, 'Burned'),
        ],
        Expanded(child: _buildWorkoutList(context, workouts)),
      ],
    );
  }

  Widget _buildMealTab(BuildContext context, List meals) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        if (meals.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildTrendChart(meals, const Color(0xFF06B6D4), isDark, 'Consumed'),
        ],
        Expanded(child: _buildMealList(context, meals)),
      ],
    );
  }

  Widget _buildTrendChart(List items, Color color, bool isDark, String label) {
    // Get last 7 days activity
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    
    final dailyData = last7Days.map((date) {
      final total = items.where((item) {
        final d = item.date;
        return d.year == date.year && d.month == date.month && d.day == date.day;
      }).fold(0.0, (sum, item) => sum + (item is WorkoutModel ? item.caloriesBurned : item.calories));
      return total;
    }).toList();

    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label Trend (kcal)', style: GoogleFonts.outfit(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[600])),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: dailyData.fold(500.0, (max, v) => v > max ? v : max) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: const FlTitlesData(show: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: dailyData.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: color,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: dailyData.fold(500.0, (max, v) => v > max ? v : max) * 1.2,
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList(BuildContext context, List workouts) {
    if (workouts.isEmpty) {
      return Center(
        child: Text(
          'No workouts logged yet.',
          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final w = workouts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.fitness_center, color: Color(0xFF6366F1)),
            title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${w.durationMinutes} mins • ${w.category}'),
            trailing: Text(
              '${w.caloriesBurned} kcal', 
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMealList(BuildContext context, List meals) {
    if (meals.isEmpty) {
      return Center(
        child: Text(
          'No meals logged yet.',
          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final m = meals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.restaurant, color: Color(0xFF06B6D4)),
            title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('P:${m.protein}g C:${m.carbs}g F:${m.fat}g'),
            trailing: Text(
              '${m.calories} kcal', 
              style: const TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
