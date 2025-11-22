class LogEntry {
  final int id;
  final String title;
  final String body; 
  final double latitude; 
  final double longitude; 

  LogEntry({
    required this.id, 
    required this.title, 
    required this.body,
    this.latitude = 0.0, 
    this.longitude = 0.0, 
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      // Symulacja lokalizacji
      latitude: (json['id'] % 50) + 40.0, 
      longitude: (json['id'] % 100) + 10.0, 
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'latitude': latitude,
      'longitude': longitude,
      'userId': 1, 
    };
  }
}