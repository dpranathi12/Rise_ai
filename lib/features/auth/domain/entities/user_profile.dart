import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final int streakCount;

  @HiveField(4)
  final int totalWakeUps;

  @HiveField(5)
  final int totalSquats;

  @HiveField(6)
  final int totalXP;

  @HiveField(7)
  final int level;

  @HiveField(8)
  final List<String> achievements;

  @HiveField(9)
  final double averageWakeUpQuality;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.streakCount = 0,
    this.totalWakeUps = 0,
    this.totalSquats = 0,
    this.totalXP = 0,
    this.level = 1,
    this.achievements = const [],
    this.averageWakeUpQuality = 0.0,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? streakCount,
    int? totalWakeUps,
    int? totalSquats,
    int? totalXP,
    int? level,
    List<String>? achievements,
    double? averageWakeUpQuality,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      streakCount: streakCount ?? this.streakCount,
      totalWakeUps: totalWakeUps ?? this.totalWakeUps,
      totalSquats: totalSquats ?? this.totalSquats,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      achievements: achievements ?? this.achievements,
      averageWakeUpQuality: averageWakeUpQuality ?? this.averageWakeUpQuality,
    );
  }
}
