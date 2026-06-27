import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rise_ai/features/ai_challenge/presentation/pages/ai_camera_screen.dart';
import 'package:rise_ai/features/alarm/domain/alarm_model.dart';

class AlarmRingingScreen extends StatelessWidget {
  final AlarmModel alarm;

  const AlarmRingingScreen({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6200EE), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                DateFormat.jm().format(alarm.time),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                "Time to Rise & Shine!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const Spacer(),
              _buildChallengePreview(context),
              const SizedBox(height: 48),
              _buildWakeUpButton(context),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengePreview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          const Icon(Icons.fitness_center, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            "Today's Challenge",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "${alarm.repetitions} ${alarm.exerciseType}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWakeUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AICameraScreen(alarm: alarm),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                "I'M AWAKE",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
