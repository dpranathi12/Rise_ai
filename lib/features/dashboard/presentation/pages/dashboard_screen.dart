import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(context),
            const SizedBox(height: 32),
            _buildSectionTitle(context, "Weekly Wake-Up Quality"),
            const SizedBox(height: 16),
            _buildQualityChart(context),
            const SizedBox(height: 32),
            _buildSectionTitle(context, "Exercise Consistency"),
            const SizedBox(height: 16),
            _buildConsistencyChart(context),
            const SizedBox(height: 32),
            _buildSectionTitle(context, "Achievements"),
            const SizedBox(height: 16),
            _buildAchievementsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(context, "Avg. Time", "6:15 AM", Icons.access_time, Colors.blue),
        const SizedBox(width: 16),
        _buildStatCard(context, "Calories", "1,240", Icons.local_fire_department, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 12),
              Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQualityChart(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 3.5),
                FlSpot(3, 5),
                FlSpot(4, 4),
                FlSpot(5, 4.5),
                FlSpot(6, 5),
              ],
              isCurved: true,
              color: Theme.of(context).primaryColor,
              barWidth: 4,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsistencyChart(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: [
            _makeGroupData(0, 5, Colors.blue),
            _makeGroupData(1, 6.5, Colors.blue),
            _makeGroupData(2, 5, Colors.blue),
            _makeGroupData(3, 7.5, Colors.blue),
            _makeGroupData(4, 9, Colors.blue),
            _makeGroupData(5, 11.5, Colors.blue),
            _makeGroupData(6, 6.5, Colors.blue),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildAchievementsGrid(BuildContext context) {
    final achievements = [
      {"name": "Early Bird", "icon": Icons.wb_sunny, "color": Colors.orange},
      {"name": "7-Day Streak", "icon": Icons.local_fire_department, "color": Colors.red},
      {"name": "500 Squats", "icon": Icons.fitness_center, "color": Colors.blue},
      {"name": "Champion", "icon": Icons.emoji_events, "color": Colors.amber},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(achievements[index]["icon"] as IconData, color: achievements[index]["color"] as Color, size: 32),
              const SizedBox(height: 8),
              Text(achievements[index]["name"] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}
