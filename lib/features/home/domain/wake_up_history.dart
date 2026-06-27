import 'package:hive/hive.dart';

part 'wake_up_history.g.dart';

@HiveType(typeId: 2)
class WakeUpHistory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final DateTime wakeUpTime;

  @HiveField(3)
  final String exerciseType;

  @HiveField(4)
  final int repetitions;

  @HiveField(5)
  final int completionTimeSeconds;

  @HiveField(6)
  final double accuracyScore;

  WakeUpHistory({
    required this.id,
    required this.date,
    required this.wakeUpTime,
    required this.exerciseType,
    required this.repetitions,
    required this.completionTimeSeconds,
    required this.accuracyScore,
  });
}
