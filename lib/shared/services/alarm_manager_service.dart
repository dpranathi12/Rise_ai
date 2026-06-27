import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:rise_ai/features/alarm/domain/alarm_model.dart';

class AlarmManagerService {
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static Future<void> scheduleAlarm(AlarmModel alarm) async {
    final int alarmId = alarm.id.hashCode;
    await AndroidAlarmManager.oneShotAt(
      alarm.time,
      alarmId,
      _alarmCallback,
      exact: true,
      wakeup: true,
      allowWhileIdle: true,
    );
  }

  static Future<void> cancelAlarm(String id) async {
    await AndroidAlarmManager.cancel(id.hashCode);
  }

  @pragma('vm:entry-point')
  static void _alarmCallback() {
    // This will be called when the alarm rings
    // In a real app, this would trigger a foreground service or a notification
    print("Alarm ringing!");
  }
}
