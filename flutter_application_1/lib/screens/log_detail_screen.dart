import 'package:flutter/material.dart';
import '../data/log_entry.dart';

class LogDetailScreen extends StatelessWidget {
  final LogEntry entry;

  const LogDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Wpisu'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              entry.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Opis:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              entry.body,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            const Text(
              'Lokalizacja GPS:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text('Szerokość (Lat): ${entry.latitude.toStringAsFixed(6)}'),
            Text('Długość (Lon): ${entry.longitude.toStringAsFixed(6)}'),
            
            const SizedBox(height: 30),
            
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Akcja: Wpis udostępniony!')),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Udostępnij Wpis'),
            ),
          ],
        ),
      ),
    );
  }
}