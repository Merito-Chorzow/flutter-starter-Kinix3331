import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/log_entry.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class AddLogScreen extends StatefulWidget {
  const AddLogScreen({super.key});

  @override
  State<AddLogScreen> createState() => _AddLogScreenState();
}

class _AddLogScreenState extends State<AddLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  
  double? _latitude;
  double? _longitude;
  
  bool _isLoadingGps = false;
  bool _isSaving = false;
  String _gpsError = '';

  final LocationService _locationService = LocationService();
  final ApiService _apiService = ApiService();

  Future<void> _getGpsLocation() async {
    setState(() {
      _isLoadingGps = true;
      _gpsError = '';
    });

    try {
      final Position position = await _locationService.getCurrentLocation();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      setState(() {
        _gpsError = e.toString().replaceFirst('Exception: ', '');
        _latitude = null;
        _longitude = null;
      });
    } finally {
      setState(() {
        _isLoadingGps = false;
      });
    }
  }

  Future<void> _saveLog() async {
    if (_formKey.currentState!.validate() && _latitude != null) {
      setState(() {
        _isSaving = true;
      });

      try {
        final newEntry = LogEntry(
          id: 0,
          title: _titleController.text,
          body: _bodyController.text,
          latitude: _latitude!,
          longitude: _longitude!,
        );

        await _apiService.saveEntry(newEntry);
        
        if (mounted) {
          Navigator.pop(context, true); 
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd zapisu: ${e.toString().replaceFirst('Exception: ', '')}')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    } else if (_latitude == null) {
      setState(() {
        _gpsError = 'Musisz pobrać lokalizację GPS.';
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Nowy Wpis'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tytuł'),
                validator: (value) => value!.isEmpty ? 'Tytuł jest wymagany.' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Opis'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Opis jest wymagany.' : null,
              ),
              const SizedBox(height: 24),
              
              ElevatedButton.icon(
                onPressed: _isLoadingGps ? null : _getGpsLocation,
                icon: _isLoadingGps
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.location_on),
                label: const Text('Pobierz Lokalizację GPS'),
              ),
              const SizedBox(height: 12),
              
              Text(
                _latitude != null
                    ? 'Lokalizacja: Lat: ${_latitude!.toStringAsFixed(6)}, Lon: ${_longitude!.toStringAsFixed(6)}'
                    : 'Lokalizacja niepobrana.',
                style: TextStyle(
                    color: _latitude != null ? Colors.green : Colors.grey[700]),
              ),
              
              if (_gpsError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(_gpsError, style: const TextStyle(color: Colors.red)),
                ),
              
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: _isSaving ? null : _saveLog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Zapisz Wpis (POST do API)', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}