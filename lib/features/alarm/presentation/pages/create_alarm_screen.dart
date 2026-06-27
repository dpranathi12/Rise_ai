import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:rise_ai/features/alarm/domain/alarm_model.dart';
import 'package:rise_ai/features/alarm/presentation/providers/alarm_provider.dart';

class CreateAlarmScreen extends ConsumerStatefulWidget {
  const CreateAlarmScreen({super.key});

  @override
  ConsumerState<CreateAlarmScreen> createState() => _CreateAlarmScreenState();
}

class _CreateAlarmScreenState extends ConsumerState<CreateAlarmScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<int> _selectedDays = [1, 2, 3, 4, 5]; // Mon-Fri
  String _exerciseType = "Squats";
  int _repetitions = 10;
  String _difficulty = "Medium";

  final List<String> _exercises = ["Squats", "Jumping Jacks", "Push-ups", "Lunges", "Stretching"];
  final List<String> _difficulties = ["Easy", "Medium", "Hard"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Alarm"),
        actions: [
          TextButton(
            onPressed: _saveAlarm,
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Wake-Up Time",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    _selectedTime.format(context),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Repeat Days",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final day = index + 1;
                final isSelected = _selectedDays.contains(day);
                final dayName = ["M", "T", "W", "T", "F", "S", "S"][index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDays.remove(day);
                      } else {
                        _selectedDays.add(day);
                      }
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        dayName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle("AI Wake-Up Challenge"),
            const SizedBox(height: 16),
            _buildDropdownField<String>(
              label: "Exercise Type",
              value: _exerciseType,
              items: _exercises,
              onChanged: (val) => setState(() => _exerciseType = val!),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildRepetitionField(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField<String>(
                    label: "Difficulty",
                    value: _difficulty,
                    items: _difficulties,
                    onChanged: (val) => setState(() => _difficulty = val!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepetitionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Repetitions", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => setState(() => _repetitions = (_repetitions > 1) ? _repetitions - 1 : 1),
              ),
              Expanded(
                child: Text(
                  _repetitions.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _repetitions++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveAlarm() {
    final now = DateTime.now();
    final alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final alarm = AlarmModel(
      id: const Uuid().v4(),
      time: alarmTime,
      days: _selectedDays,
      soundPath: "default",
      exerciseType: _exerciseType,
      repetitions: _repetitions,
      difficulty: _difficulty,
    );

    ref.read(alarmListProvider.notifier).addAlarm(alarm);
    Navigator.of(context).pop();
  }
}
