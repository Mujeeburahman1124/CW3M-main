import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/app_theme.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  double? _bmi;
  String _message = '';
  Color _messageColor = Colors.white;

  void _calculateBMI() {
    final heightText = _heightController.text;
    final weightText = _weightController.text;

    if (heightText.isEmpty || weightText.isEmpty) return;

    final height = double.tryParse(heightText); // in cm
    final weight = double.tryParse(weightText); // in kg

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      setState(() {
        _message = 'Please enter valid values';
        _bmi = null;
      });
      return;
    }

    // BMI = weight (kg) / [height (m)]^2
    final heightInMeters = height / 100;
    final bmiValue = weight / (heightInMeters * heightInMeters);

    setState(() {
      _bmi = bmiValue;
      if (_bmi! < 18.5) {
        _message = 'Underweight';
        _messageColor = Colors.orange;
      } else if (_bmi! < 25) {
        _message = 'Normal';
        _messageColor = Colors.green;
      } else if (_bmi! < 30) {
        _message = 'Overweight';
        _messageColor = Colors.orange;
      } else {
        _message = 'Obese';
        _messageColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(isDark),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('BMI Calculator', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Calculate your Body Mass Index',
                      style: GoogleFonts.outfit(
                        fontSize: 18, 
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        prefixIcon: Icon(Icons.height_rounded),
                        hintText: 'e.g. 175',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        prefixIcon: Icon(Icons.monitor_weight_rounded),
                        hintText: 'e.g. 70',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _calculateBMI,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF6366F1),
                      ),
                      child: Text(
                        'Calculate BMI', 
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    if (_bmi != null) ...[
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: _messageColor.withValues(alpha: 0.3)),
                          boxShadow: isDark ? [] : [
                            BoxShadow(
                              color: _messageColor.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your BMI',
                              style: GoogleFonts.outfit(
                                fontSize: 20, 
                                color: isDark ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _bmi!.toStringAsFixed(1),
                              style: GoogleFonts.outfit(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: _messageColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _message,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _messageColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
