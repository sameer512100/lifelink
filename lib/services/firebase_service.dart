import 'package:firebase_database/firebase_database.dart';
import '../models/donation_request.dart';

class FirebaseService {
  final DatabaseReference _donationsRef =
      FirebaseDatabase.instance.ref().child("donationRequests");

  // Fetch donation requests from Firebase
  Future<List<DonationRequest>> fetchDonationRequests() async {
    DataSnapshot snapshot = await _donationsRef.get();

    if (snapshot.exists && snapshot.value is Map) {
      Map<dynamic, dynamic> requestsMap = snapshot.value as Map;
      List<DonationRequest> donationRequests = [];

      requestsMap.forEach((key, value) {
        donationRequests.add(DonationRequest.fromMap(key, value));
      });

      return donationRequests;
    } else {
      return [];
    }
  }

  // Add default dummy donation requests (call this once if needed)
  Future<void> addDefaultDonationRequests() async {
    try {
      await _donationsRef.set({
        "req1": {
          "donorName": "Alice Johnson",
          "bloodType": "A+",
          "location": "New York",
          "contact": "1234567890",
          "timestamp": DateTime.now().toIso8601String(),
        },
        "req2": {
          "donorName": "Bob Smith",
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
