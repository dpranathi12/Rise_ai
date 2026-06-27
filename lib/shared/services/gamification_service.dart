import 'package:rise_ai/features/auth/domain/entities/user_profile.dart';

class GamificationService {
  static UserProfile updateProgress(UserProfile profile, int reps, double accuracy) {
    int xpGained = (reps * 10 * accuracy).toInt();
    int newTotalXP = profile.totalXP + xpGained;
    int newLevel = (newTotalXP / 1000).floor() + 1;
    
    List<String> newAchievements = List.from(profile.achievements);
    if (profile.streakCount + 1 == 7 && !newAchievements.contains("7-Day Streak")) {
      newAchievements.add("7-Day Streak");
    }
    if (profile.totalSquats + reps >= 500 && !newAchievements.contains("500 Squats")) {
      newAchievements.add("500 Squats");
    }

    return profile.copyWith(
      totalXP: newTotalXP,
      level: newLevel,
      streakCount: profile.streakCount + 1,
      totalWakeUps: profile.totalWakeUps + 1,
      totalSquats: profile.totalSquats + reps,
      achievements: newAchievements,
    );
  }
}
