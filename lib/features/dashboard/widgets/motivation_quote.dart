import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MotivationQuoteWidget extends StatelessWidget {
  const MotivationQuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quotes = [
      {
        'text': 'The only bad workout is the one that didn\'t happen.',
        'author': 'Anonymous',
        'image': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=800&q=80'
      },
      {
        'text': 'Action is the foundational key to all success.',
        'author': 'Pablo Picasso',
        'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&q=80'
      },
      {
        'text': 'Don\'t count the days, make the days count.',
        'author': 'Muhammad Ali',
        'image': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80'
      },
      {
        'text': 'The pain you feel today will be the strength you feel tomorrow.',
        'author': 'Arnold Schwarzenegger',
        'image': 'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?w=800&q=80'
      },
      {
        'text': 'Fitness is not about being better than someone else. It\'s about being better than you were yesterday.',
        'author': 'Khloe Kardashian',
        'image': 'https://images.unsplash.com/photo-1483721310020-03333e577078?w=800&q=80'
      },
      {
        'text': 'Motivation is what gets you started. Habit is what keeps you going.',
        'author': 'Jim Ryun',
        'image': 'https://images.unsplash.com/photo-1552674605-46d502a2dbbd?w=800&q=80'
      },
    ];

    // Pick a quote based on the day of the year to ensure it changes daily
    final index = DateTime.now().day % quotes.length;
    final quote = quotes[index];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(quote['image']!),
          fit: BoxFit.cover,
          opacity: isDark ? 0.3 : 0.15,
        ),
        gradient: LinearGradient(
          colors: isDark ? [
            const Color(0xFF6366F1).withValues(alpha: 0.8),
            const Color(0xFF0F172A).withValues(alpha: 0.95),
          ] : [
            const Color(0xFF6366F1).withValues(alpha: 0.9),
            const Color(0xFF818CF8).withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            quote['text']!,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 24,
                height: 2,
                color: const Color(0xFF06B6D4),
              ),
              const SizedBox(width: 8),
              Text(
                quote['author']!,
                style: GoogleFonts.outfit(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
