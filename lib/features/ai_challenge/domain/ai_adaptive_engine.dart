import 'package:rise_ai/features/home/domain/wake_up_history.dart';

class AIAdaptiveEngine {
  static Map<String, dynamic> calculateNextChallenge(List<WakeUpHistory> history) {
    if (history.isEmpty) {
      return {
        "exerciseType": "Squats",
        "repetitions": 10,
        "difficulty": "Easy",
        "message": "Welcome! Let's start with 10 squats today."
      };
    }

    // Simple logic for demonstration
    final lastSevenDays = history.take(7).toList();
    final completionRate = lastSevenDays.length / 7;
    final averageAccuracy = lastSevenDays.map((e) => e.accuracyScore).reduce((a, b) => a + b) / lastSevenDays.length;

    String nextExercise = "Squats";
    int nextReps = 10;
    String nextDifficulty = "Medium";
    String message = "Keep it up!";

    if (completionRate > 0.8 && averageAccuracy > 0.9) {
      nextReps = (lastSevenDays.first.repetitions * 1.2).toInt();
      nextDifficulty = "Hard";
      message = "You're crushing it! Challenge increased.";
    } else if (completionRate < 0.5) {
      nextReps = (lastSevenDays.first.repetitions * 0.8).toInt();
      nextDifficulty = "Easy";
      message = "Let's take it easy today to get back on track.";
    }

    return {
      "exerciseType": nextExercise,
      "repetitions": nextReps.clamp(5, 50),
      "difficulty": nextDifficulty,
      "message": message
    };
  }
}
