import 'package:hive/hive.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime time;

  @HiveField(2)
  final List<int> days; // 1 for Monday, 7 for Sunday

  @HiveField(3)
  final bool isEnabled;

  @HiveField(4)
  final String soundPath;

  @HiveField(5)
  final bool vibrate;

  @HiveField(6)
  final String exerciseType;

  @HiveField(7)
  final int repetitions;

  @HiveField(8)
  final String difficulty;

  AlarmModel({
    required this.id,
    required this.time,
    required this.days,
    this.isEnabled = true,
    required this.soundPath,
    this.vibrate = true,
    required this.exerciseType,
    required this.repetitions,
    required this.difficulty,
  });

  AlarmModel copyWith({
    String? id,
    DateTime? time,
    List<int>? days,
    bool? isEnabled,
    String? soundPath,
    bool? vibrate,
    String? exerciseType,
    int? repetitions,
    String? difficulty,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      time: time ?? this.time,
      days: days ?? this.days,
      isEnabled: isEnabled ?? this.isEnabled,
      soundPath: soundPath ?? this.soundPath,
      vibrate: vibrate ?? this.vibrate,
      exerciseType: exerciseType ?? this.exerciseType,
      repetitions: repetitions ?? this.repetitions,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
