class MotivationEngine {
  static const List<String> _quotes = [
    "The early bird catches the worm, but the AI bird makes sure you're actually awake.",
    "Your future self will thank you for waking up now.",
    "Success starts with a consistent morning routine.",
    "Don't snooze your dreams. Rise and shine!",
    "Every morning is a fresh start. Make it count.",
    "You are one workout away from a good mood.",
    "Discipline is doing what needs to be done, even if you don't want to do it.",
  ];

  static String getDailyQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return _quotes[dayOfYear % _quotes.length];
  }

  static String getStreakMessage(int streak) {
    if (streak == 0) return "Start your streak today!";
    if (streak == 1) return "Great start! Keep the momentum going.";
    if (streak < 7) return "You're on a $streak-day streak. Keep building the habit.";
    return "Amazing! $streak-day streak. You're a champion!";
  }
}
