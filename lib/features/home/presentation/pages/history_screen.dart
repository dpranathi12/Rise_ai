import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wake-Up History")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: index));
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.check, color: Theme.of(context).primaryColor),
                ),
              ),
              title: Text(
                DateFormat('EEEE, MMM d').format(date),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Squats - 15 reps • 6:05 AM"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("95%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  Text("Accuracy", style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
