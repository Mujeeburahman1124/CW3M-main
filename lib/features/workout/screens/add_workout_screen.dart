import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/workout_model.dart';
import '../providers/workout_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/utils/app_theme.dart';

class AddWorkoutScreen extends ConsumerStatefulWidget {
  final WorkoutModel? workout;
  const AddWorkoutScreen({super.key, this.workout});

  @override
  ConsumerState<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends ConsumerState<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _durationController;
  late TextEditingController _caloriesController;
  String _category = 'Strength';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workout?.name);
    _descController = TextEditingController(text: widget.workout?.description);
    _durationController = TextEditingController(text: widget.workout?.durationMinutes.toString() ?? '30');
    _caloriesController = TextEditingController(text: widget.workout?.caloriesBurned.toString() ?? '200');
    if (widget.workout != null) _category = widget.workout!.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
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
              title: Text(widget.workout == null ? 'Add Workout' : 'Edit Workout'),
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
                      decoration: const InputDecoration(labelText: 'Workout Name', hintText: 'e.g. Chest Day'),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(labelText: 'Description', hintText: 'Optional'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _durationController,
                            decoration: const InputDecoration(labelText: 'Duration (mins)'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _caloriesController,
                            decoration: const InputDecoration(labelText: 'Calories Burned'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      dropdownColor: isDark ? AppTheme.surfaceColor : Colors.white,
                      items: ['Strength', 'Cardio', 'Flexibility', 'HIIT', 'Yoga']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _category = v!),
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

                          final workout = WorkoutModel(
                            id: widget.workout?.id ?? const Uuid().v4(),
                            name: _nameController.text,
                            description: _descController.text,
                            durationMinutes: int.tryParse(_durationController.text) ?? 0,
                            caloriesBurned: int.tryParse(_caloriesController.text) ?? 0,
                            category: _category,
                            date: widget.workout?.date ?? DateTime.now(),
                            userId: currentUser.uid,
                          );
                          if (widget.workout == null) {
                            ref.read(workoutListProvider.notifier).addWorkout(workout);
                          } else {
                            ref.read(workoutListProvider.notifier).updateWorkout(workout);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save Workout'),
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
