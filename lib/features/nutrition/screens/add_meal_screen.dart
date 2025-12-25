import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/meal_model.dart';
import '../providers/nutrition_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/utils/app_theme.dart';

class AddMealScreen extends ConsumerStatefulWidget {
  final MealModel? meal;
  const AddMealScreen({super.key, this.meal});

  @override
  ConsumerState<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends ConsumerState<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meal?.name);
    _caloriesController = TextEditingController(text: widget.meal?.calories.toString() ?? '300');
    _proteinController = TextEditingController(text: widget.meal?.protein.toString() ?? '20');
    _carbsController = TextEditingController(text: widget.meal?.carbs.toString() ?? '40');
    _fatController = TextEditingController(text: widget.meal?.fat.toString() ?? '10');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey[600];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(isDark),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text(widget.meal == null ? 'Add Meal' : 'Edit Meal'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Meal Name', hintText: 'e.g. Grilled Chicken'),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    Text('Macros (grams)', style: TextStyle(fontWeight: FontWeight.bold, color: secondaryTextColor)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _proteinController,
                            decoration: const InputDecoration(labelText: 'Protein'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _carbsController,
                            decoration: const InputDecoration(labelText: 'Carbs'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _fatController,
                            decoration: const InputDecoration(labelText: 'Fat'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final currentUser = ref.read(authStateProvider).value;
                          if (currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('⚠️ Please login first')),
                            );
                            return;
                          }

                          final meal = MealModel(
                            id: widget.meal?.id ?? const Uuid().v4(),
                            name: _nameController.text,
                            calories: int.tryParse(_caloriesController.text) ?? 0,
                            protein: double.tryParse(_proteinController.text) ?? 0,
                            carbs: double.tryParse(_carbsController.text) ?? 0,
                            fat: double.tryParse(_fatController.text) ?? 0,
                            date: widget.meal?.date ?? DateTime.now(),
                            userId: currentUser.uid,
                          );
                          
                          final isEditing = widget.meal != null;
                          
                          if (isEditing) {
                            ref.read(mealListProvider.notifier).updateMeal(meal);
                          } else {
                            ref.read(mealListProvider.notifier).addMeal(meal);
                          }
                          
                          Navigator.pop(context);
                          
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isEditing 
                                  ? '✅ Meal updated successfully!' 
                                  : '✅ Meal saved successfully!',
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(widget.meal == null ? 'Save Meal' : 'Update Meal'),
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
}
