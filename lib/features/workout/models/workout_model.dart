import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 0)
class WorkoutModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final int durationMinutes;
  
  @HiveField(4)
  final String category;
  
  @HiveField(5)
  final int caloriesBurned;
  
  @HiveField(6)
  final DateTime date;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.description,
    required this.durationMinutes,
    required this.category,
    required this.caloriesBurned,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'durationMinutes': durationMinutes,
      'category': category,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      category: json['category'],
      caloriesBurned: (json['caloriesBurned'] as num).toInt(),
      date: DateTime.parse(json['date']),
    );
  }

  WorkoutModel copyWith({
    String? name,
    String? description,
    int? durationMinutes,
    String? category,
    int? caloriesBurned,
    DateTime? date,
  }) {
    return WorkoutModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      date: date ?? this.date,
    );
  }
}
