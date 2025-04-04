import 'package:firebase_database/firebase_database.dart';
import '../models/donation_request.dart';

class FirebaseService {
  final DatabaseReference _donationsRef =
      FirebaseDatabase.instance.ref().child("donationRequests");

  Future<List<DonationRequest>> fetchDonationRequests() async {
    DataSnapshot snapshot = await _donationsRef.get();
    if (snapshot.exists && snapshot.value is Map) {
      final Map<dynamic, dynamic> requestsMap = snapshot.value as Map;
      return requestsMap.entries.map((e) => DonationRequest.fromMap(e.key, e.value)).toList();
    } else {
      return [];
    }
  }

  Future<void> addDonationRequest(DonationRequest request) async {
    await _donationsRef.child(request.id).set(request.toMap());
  }

  Future<void> addDefaultDonationRequests() async {
    try {
      await _donationsRef.set({
        "req1": {
          "hospitalName": "New York General Hospital",
          "bloodType": "A+",
          "location": "New York",
          "contact": "1234567890",
          "timestamp": DateTime.now().toIso8601String(),
        },
        "req2": {
          "hospitalName": "Chicago Care Center",
          "bloodType": "B-",
          "location": "Chicago",
          "contact": "9876543210",
          "timestamp": DateTime.now().toIso8601String(),
        }
      });
      print("✅ Default donation requests added to Firebase!");
    } catch (e) {
      print("❌ Error adding default donation requests: $e");
    }
  }
}
