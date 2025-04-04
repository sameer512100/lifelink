import 'package:firebase_database/firebase_database.dart';
import '../models/donation_request.dart';

class FirebaseService {
  final DatabaseReference _donationsRef =
      FirebaseDatabase.instance.ref().child("donationRequests");

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
}
