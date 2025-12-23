import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../workout/providers/workout_provider.dart';
import 'package:fitflow_fitness_assistant/core/utils/app_theme.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(isDark),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Progress'),
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatCard(context, 'Total Workouts', workouts.length.toString(), Icons.fitness_center, Colors.indigo),
                  const SizedBox(height: 16),
                  _buildStatCard(context, 'Total Minutes', workouts.fold(0, (sum, w) => sum + w.durationMinutes).toString(), Icons.timer, Colors.cyan),
                  const SizedBox(height: 16),
                  _buildStatCard(context, 'Total Calories', workouts.fold(0, (sum, w) => sum + w.caloriesBurned).toString(), Icons.local_fire_department, const Color(0xFFF43F5E)),
                  const SizedBox(height: 32),
                  Text(
                    'Weekly Activity',
                    style: GoogleFonts.outfit(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: isDark ? Colors.white : AppTheme.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
                      boxShadow: isDark ? [] : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _getMaxY(workouts),
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    DateFormat('E').format(date),
                                    style: TextStyle(
                                      color: isDark ? Colors.white38 : Colors.grey, 
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: _getBarGroups(workouts, isDark),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(List workouts) {
    double max = 0;
    for (int i = 0; i < 7; i++) {
       final date = DateTime.now().subtract(Duration(days: i));
       final dayTotal = workouts
          .where((w) => w.date.day == date.day && w.date.month == date.month && w.date.year == date.year)
          .fold(0.0, (sum, w) => sum + w.caloriesBurned);
       if (dayTotal > max) max = dayTotal;
    }
    return max == 0 ? 100 : max * 1.2;
  }

  List<BarChartGroupData> _getBarGroups(List workouts, bool isDark) {
    return List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final dayCalories = workouts
          .where((w) => w.date.day == date.day && w.date.month == date.month && w.date.year == date.year)
          .fold(0.0, (sum, w) => sum + w.caloriesBurned);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: dayCalories,
            color: const Color(0xFF6366F1),
            width: 14,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(workouts),
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 13)),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.lightTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
