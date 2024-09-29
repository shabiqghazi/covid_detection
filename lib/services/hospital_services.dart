import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalServices {
  Future<List<dynamic>> getDocs(GeoPoint currentLocation) async {
    final distance = 0.5;

    final double lowerLat = currentLocation.latitude - distance;
    final double lowerLon = currentLocation.longitude - distance;
    final double greaterLat = currentLocation.latitude + distance;
    final double greaterLon = currentLocation.longitude + distance;
    final lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    final greaterGeopoint = GeoPoint(greaterLat, greaterLon);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'hospital')
          // .where('geoPoint',
          //     isGreaterThan: lesserGeopoint, isLessThan: greaterGeopoint)
          .get();
      final allData = querySnapshot.docs.map((doc) {
        final String documentId = doc.id;
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'documentId': documentId,
        };
      }).toList();
      return allData;
    } catch (e) {
      print("Error connecting to Firestore: $e");
    }
    // Get data from docs and convert them to List
    return [];
  }
}
