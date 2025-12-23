import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hive/hive.dart';

class WaterTrackerWidget extends StatefulWidget {
  const WaterTrackerWidget({super.key});

  @override
  State<WaterTrackerWidget> createState() => _WaterTrackerWidgetState();
}

class _WaterTrackerWidgetState extends State<WaterTrackerWidget> {
  int _glasses = 0;
  final int _goal = 8;
  final String _boxName = 'settingsBox';
  final String _key = 'water_intake_${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final box = Hive.box(_boxName);
    setState(() {
      _glasses = box.get(_key, defaultValue: 0);
    });
  }

  Future<void> _updateData(int newValue) async {
    final box = Hive.box(_boxName);
    await box.put(_key, newValue);
    setState(() {
      _glasses = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? null : Colors.white,
        gradient: isDark ? LinearGradient(
          colors: [
            const Color(0xFF06B6D4).withValues(alpha: 0.2),
            const Color(0xFF6366F1).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ) : null,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Water Intake',
                    style: GoogleFonts.outfit(
                      color: primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Daily Goal: $_goal glasses',
                    style: GoogleFonts.outfit(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_drink_rounded,
                  color: Color(0xFF06B6D4),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_glasses / $_goal',
                style: GoogleFonts.outfit(
                  color: primaryTextColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  _ActionButton(
                    icon: Icons.remove_rounded,
                    isDark: isDark,
                    onTap: () {
                      if (_glasses > 0) _updateData(_glasses - 1);
                    },
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    icon: Icons.add_rounded,
                    isDark: isDark,
                    onTap: () {
                      if (_glasses < _goal) _updateData(_glasses + 1);
                    },
                    primary: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                height: 8,
                width: (_glasses / _goal).isNaN ? 0 : (MediaQuery.of(context).size.width - 80) * (_glasses / _goal),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  final bool isDark;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary ? const Color(0xFF06B6D4) : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: primary ? Colors.white : (isDark ? Colors.white60 : Colors.grey[600]),
          size: 20,
        ),
      ),
    );
  }
}
