import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_progress_card.dart';
import '../widgets/water_tracker.dart';
import '../widgets/motivation_quote.dart';
import '../widgets/streak_counter.dart';
import '../../workout/screens/workout_screen.dart';
import '../../nutrition/screens/nutrition_screen.dart';
import 'progress_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../workout/providers/workout_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'package:fitflow_fitness_assistant/core/utils/app_theme.dart';
import '../providers/stats_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardContent(),
    const WorkoutScreen(),
    const NutritionScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: isDark ? Colors.white24 : Colors.grey[400],
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_rounded), label: 'Training'),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_rounded), label: 'Nutrition'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class DashboardContent extends ConsumerWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutListProvider);
    final streakDays = ref.watch(streakProvider);

    final totalCaloriesBurned =
        workouts.fold(0, (sum, w) => sum + w.caloriesBurned);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppTheme.lightTextColor;
    final tertiaryTextColor =
        isDark ? Colors.white38 : (Colors.grey[500] ?? Colors.grey);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(isDark),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              expandedHeight: 80,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt_rounded,
                        color: Color(0xFF6366F1)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'FitFlow',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: primaryTextColor,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _showNotificationsBottomSheet(context, isDark);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 12),
                  const MotivationQuoteWidget(),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome back, ${ref.watch(profileProvider).name}!',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreakCounterWidget(streakDays: streakDays),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily Goals',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Edit Targets'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomProgressCard(
                          title: 'Workouts',
                          value: workouts.length.toString(),
                          subtitle: 'Sept',
                          icon: Icons.fitness_center_rounded,
                          color: const Color(0xFF6366F1),
                          progress: (workouts.length / 5).clamp(0.0, 1.0),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomProgressCard(
                          title: 'Burned',
                          value: totalCaloriesBurned.toString(),
                          subtitle: 'kcal',
                          icon: Icons.local_fire_department_rounded,
                          color: const Color(0xFFF43F5E),
                          progress:
                              (totalCaloriesBurned / 2000).clamp(0.0, 1.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const WaterTrackerWidget(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded,
                            size: 16, color: tertiaryTextColor),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (workouts.isEmpty)
                    _buildEmptyActivity(isDark, tertiaryTextColor)
                  else
                    ...workouts.take(3).map((w) => _buildActivityTile(
                        w, isDark, primaryTextColor, tertiaryTextColor)),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyActivity(bool isDark, Color tertiaryTextColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color:
                (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(Icons.history_rounded, size: 48, color: tertiaryTextColor),
          const SizedBox(height: 16),
          Text(
            'No activities today',
            style: GoogleFonts.outfit(color: tertiaryTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(
      dynamic w, bool isDark, Color primaryTextColor, Color tertiaryTextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.fitness_center_rounded,
              color: Color(0xFF6366F1), size: 20),
        ),
        title: Text(
          w.name,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        subtitle: Text(
          '${w.durationMinutes} mins • ${w.category}',
          style: GoogleFonts.outfit(color: tertiaryTextColor),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${w.caloriesBurned}',
              style: GoogleFonts.outfit(
                color: const Color(0xFFF43F5E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'kcal',
              style: GoogleFonts.outfit(
                color: tertiaryTextColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showNotificationsBottomSheet(BuildContext context, bool isDark) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.lightTextColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white : AppTheme.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
          // Notifications list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildNotificationItem(
                  context,
                  isDark,
                  icon: Icons.fitness_center_rounded,
                  iconColor: const Color(0xFF6366F1),
                  title: 'Time to Exercise!',
                  message: 'You haven\'t worked out today. Let\'s get moving!',
                  time: '2 hours ago',
                ),
                _buildNotificationItem(
                  context,
                  isDark,
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFF43F5E),
                  title: 'Streak Alert! 🔥',
                  message: 'You\'re on a ${3}-day streak. Keep it going!',
                  time: '5 hours ago',
                ),
                _buildNotificationItem(
                  context,
                  isDark,
                  icon: Icons.restaurant_rounded,
                  iconColor: const Color(0xFF10B981),
                  title: 'Meal Reminder',
                  message: 'Don\'t forget to log your dinner!',
                  time: '6 hours ago',
                ),
                _buildNotificationItem(
                  context,
                  isDark,
                  icon: Icons.emoji_events_rounded,
                  iconColor: const Color(0xFFFBBF24),
                  title: 'Achievement Unlocked!',
                  message: 'You\'ve completed 10 workouts this month!',
                  time: '1 day ago',
                ),
                _buildNotificationItem(
                  context,
                  isDark,
                  icon: Icons.water_drop_rounded,
                  iconColor: const Color(0xFF06B6D4),
                  title: 'Stay Hydrated',
                  message:
                      'You\'ve only logged 4 glasses today. Drink more water!',
                  time: '1 day ago',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNotificationItem(
  BuildContext context,
  bool isDark, {
  required IconData icon,
  required Color iconColor,
  required String title,
  required String message,
  required String time,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF0F172A) : Colors.grey[50],
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.1),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : AppTheme.lightTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                time,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
