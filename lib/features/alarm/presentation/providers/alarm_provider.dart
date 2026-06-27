import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rise_ai/features/alarm/domain/alarm_model.dart';

final alarmBoxProvider = Provider<Box<AlarmModel>>((ref) {
  return Hive.box<AlarmModel>('alarms');
});

final alarmListProvider = StateNotifierProvider<AlarmListNotifier, List<AlarmModel>>((ref) {
  final box = ref.watch(alarmBoxProvider);
  return AlarmListNotifier(box);
});

class AlarmListNotifier extends StateNotifier<List<AlarmModel>> {
  final Box<AlarmModel> _box;

  AlarmListNotifier(this._box) : super([]) {
    _loadAlarms();
  }

  void _loadAlarms() {
    state = _box.values.toList();
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    await _box.put(alarm.id, alarm);
    state = [...state, alarm];
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    await _box.put(alarm.id, alarm);
    state = [
      for (final a in state)
        if (a.id == alarm.id) alarm else a
    ];
  }

  Future<void> deleteAlarm(String id) async {
    await _box.delete(id);
    state = state.where((a) => a.id != id).toList();
  }

  Future<void> toggleAlarm(String id) async {
    final alarm = state.firstWhere((a) => a.id == id);
    final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
    await updateAlarm(updatedAlarm);
  }
}
