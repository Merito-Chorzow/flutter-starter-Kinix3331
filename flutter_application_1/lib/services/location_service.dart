import 'package:geolocator/geolocator.dart';

class LocationService {
  
  Future<Position> getCurrentLocation() async {
    
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Future.error('Usługi lokalizacyjne (GPS) są wyłączone na urządzeniu.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied) {
        throw Future.error('Odmowa dostępu do lokalizacji przez użytkownika.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Future.error(
        'Uprawnienia do lokalizacji zostały trwale odrzucone.'
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }
}