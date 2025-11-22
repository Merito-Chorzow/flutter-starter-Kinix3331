import 'package:flutter/material.dart';
import '../data/log_entry.dart';
import '../services/api_service.dart';
import 'log_detail_screen.dart';
import 'add_log_screen.dart';

class LogListScreen extends StatefulWidget {
  const LogListScreen({super.key});

  @override
  State<LogListScreen> createState() => _LogListScreenState();
}

class _LogListScreenState extends State<LogListScreen> {
  late Future<List<LogEntry>> _entriesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _entriesFuture = _apiService.fetchEntries();
  }
  
  void _refreshEntries() {
    setState(() {
      _entriesFuture = _apiService.fetchEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dziennik Lokalizacji'),
        backgroundColor: Colors.blueGrey,
      ),
      
      body: FutureBuilder<List<LogEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Błąd: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } 
          
          else if (snapshot.hasData) {
            final entries = snapshot.data!;

            if (entries.isEmpty) {
              return const Center(
                child: Text('Brak wpisów. Kliknij "+" aby dodać pierwszy!', 
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
              );
            }
            
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  title: Text(entry.title),
                  subtitle: Text('Lat: ${entry.latitude.toStringAsFixed(4)}, Lon: ${entry.longitude.toStringAsFixed(4)}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogDetailScreen(entry: entry), 
                      ),
                    );
                  },
                );
              },
            );
          }
          
          return const Center(child: Text('Brak danych.'));
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLogScreen()),
          );
          
          if (result == true) {
            _refreshEntries();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}