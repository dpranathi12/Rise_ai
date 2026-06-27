import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rise_ai/core/theme/app_theme.dart';
import 'package:rise_ai/features/onboarding/presentation/pages/splash_screen.dart';

import 'package:rise_ai/features/alarm/domain/alarm_model.dart';
import 'package:rise_ai/features/auth/domain/entities/user_profile.dart';
import 'package:rise_ai/features/home/domain/wake_up_history.dart';
import 'package:rise_ai/shared/services/notification_service.dart';
import 'package:rise_ai/shared/services/alarm_manager_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize Services
  await NotificationService.init();
  await AlarmManagerService.init();
  
  // Register Adapters
  Hive.registerAdapter(AlarmModelAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(WakeUpHistoryAdapter());
  
  // Open Boxes
  await Hive.openBox<AlarmModel>('alarms');
  await Hive.openBox<UserProfile>('user_profile');
  await Hive.openBox<WakeUpHistory>('wake_up_history');
  
  runApp(
    const ProviderScope(
      child: RiseAIApp(),
    ),
  );
}

class RiseAIApp extends StatelessWidget {
  const RiseAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiseAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
