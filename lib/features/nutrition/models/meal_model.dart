import 'package:hive/hive.dart';

part 'meal_model.g.dart';

@HiveType(typeId: 1)
class MealModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int calories;
  
  @HiveField(3)
  final double protein;
  
  @HiveField(4)
  final double carbs;
  
  @HiveField(5)
  final double fat;
  
  @HiveField(6)
  final DateTime date;

  @HiveField(7)
  final String userId;

  MealModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      name: json['name'],
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      userId: json['userId'] ?? '',
    );
  }

  MealModel copyWith({
    String? name,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    DateTime? date,
    String? userId,
  }) {
    return MealModel(
      id: id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }
}
