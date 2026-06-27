import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rise_ai/features/alarm/presentation/providers/alarm_provider.dart';
import 'package:rise_ai/features/alarm/domain/alarm_model.dart';
import 'package:rise_ai/features/alarm/presentation/pages/create_alarm_screen.dart';
import 'package:rise_ai/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:rise_ai/features/home/presentation/pages/history_screen.dart';
import 'package:rise_ai/features/settings/presentation/pages/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const DashboardScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Analytics"),
          NavigationDestination(icon: Icon(Icons.history), label: "History"),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: "Settings"),
        ],
      ),
    );
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("RiseAI"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Alarms",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreateAlarmScreen()),
                    );
                  },
                  child: const Text("Add New"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (alarms.isEmpty)
              _buildEmptyAlarms(context)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  return _buildAlarmItem(context, ref, alarms[index]);
                },
              ),
            const SizedBox(height: 24),
            _buildAIRecommendation(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateAlarmScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Streak",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    Text(
                      "7 Days",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(color: Colors.white24, thickness: 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wake-Up Score",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    Text(
                      "92%",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAlarms(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.alarm_add, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No alarms set yet",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmItem(BuildContext context, WidgetRef ref, AlarmModel alarm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          DateFormat.jm().format(alarm.time),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          "${alarm.exerciseType} - ${alarm.repetitions} reps",
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Switch(
          value: alarm.isEnabled,
          onChanged: (value) {
            ref.read(alarmListProvider.notifier).toggleAlarm(alarm.id);
          },
        ),
        onTap: () {
          // Edit alarm logic
        },
      ),
    );
  }

  Widget _buildAIRecommendation(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.orange),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI Recommendation",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text(
                    "Based on your consistency, tomorrow's challenge will be 15 squats.",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
