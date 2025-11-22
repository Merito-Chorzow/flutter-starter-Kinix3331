import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/log_entry.dart';

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<LogEntry>> fetchEntries() async {
    final response = await http.get(Uri.parse('$_baseUrl/posts'));

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      
      return jsonList.map((json) => LogEntry.fromJson(json)).toList();
    } else {
      throw Exception('Błąd połączenia: Nie udało się pobrać wpisów.');
    }
  }

  Future<LogEntry> saveEntry(LogEntry newEntry) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newEntry.toJson()),
    );

    if (response.statusCode == 201) {
      return LogEntry.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Błąd: Nie udało się zapisać nowego wpisu.');
    }
  }
}