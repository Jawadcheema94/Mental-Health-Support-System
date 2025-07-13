import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getLocationDetails(
      double lat, double lng) async {
    try {
      // Reverse geocoding to get address details
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'latitude': lat,
          'longitude': lng,
          'address': data['display_name'] ?? 'Unknown location',
          'city': data['address']?['city'] ??
              data['address']?['town'] ??
              'Unknown city',
          'country': data['address']?['country'] ?? 'Unknown country',
          'source': 'GPS',
        };
      }
    } catch (e) {
      print('Error getting location details: $e');
    }

    return {
      'latitude': lat,
      'longitude': lng,
      'address':
          'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}',
      'city': 'Unknown',
      'country': 'Unknown',
      'source': 'GPS',
    };
  }

  static Future<List<dynamic>?> findNearbyTherapists(double lat, double lng,
      {double radius = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.2.105:3000/api/therapists/nearby?lat=$lat&lng=$lng&radius=$radius'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['therapists'];
      }
    } catch (e) {
      print('Error finding nearby therapists: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> updateUserLocation(
      String userId, double lat, double lng) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.2.105:3000/api/location/update'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'latitude': lat,
          'longitude': lng,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error updating user location: $e');
    }
    return null;
  }

  static double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) /
        1000; // Convert to kilometers
  }

  static Future<Map<String, dynamic>?> getIPBasedLocation() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.2.105:3000/api/location/ip-geo'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data['source'] = 'IP';
        return data;
      }
    } catch (e) {
      print('Error getting IP-based location: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getBestAvailableLocation() async {
    // Try GPS first
    final position = await getCurrentPosition();
    if (position != null) {
      return await getLocationDetails(position.latitude, position.longitude);
    }

    // Fallback to IP-based location
    return await getIPBasedLocation();
  }
}
