import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔁 Stream donation requests for a specific hospital
  Stream<List<DonationRequest>> getHospitalDonationRequests(String hospitalName) {
    return _firestore
        .collection('donationRequests')
        .where('hospitalName', isEqualTo: hospitalName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DonationRequest.fromMap(doc.id, doc.data()))
            .toList());
  }

  // 🔁 Stream all donation requests (for donors to see all)
  Stream<List<DonationRequest>> fetchDonationRequests() {
    try {
      print("Fetching donation requests from 'donationRequests'...");
      return _firestore
          .collection('donationRequests')
          .snapshots()
          .map((snapshot) {
            print("Snapshot received - Docs count: ${snapshot.docs.length}");
            if (snapshot.docs.isEmpty) {
              print("No documents found in 'donationRequests' collection.");
            } else {
              print("Documents found: ${snapshot.docs.map((doc) => doc.data())}");
            }
            return snapshot.docs
                .map((doc) {
                  try {
                    return DonationRequest.fromMap(doc.id, doc.data());
                  } catch (e) {
                    print("Error mapping document ${doc.id}: $e");
                    return null; // Skip invalid documents
                  }
                })
                .where((request) => request != null)
                .cast<DonationRequest>()
                .toList();
          })
          .handleError((error) {
            print("Error fetching donation requests: $error");
            throw error; // Propagate to StreamBuilder
          });
    } catch (e) {
      print("Unexpected error in fetchDonationRequests: $e");
      rethrow;
    }
  }

  // ➕ Add a new donation request
  Future<void> addDonationRequest(DonationRequest request) async {
    try {
      await _firestore
          .collection('donationRequests')
          .doc(request.id)
          .set(request.toMap());
      print("Donation request added: ${request.id}");
    } catch (e) {
      print("❌ Error adding donation request: $e");
      rethrow; // Propagate error
    }
  }

  // ✅ Accept a donation request
  Future<void> acceptDonationRequest(String requestId) async {
    try {
      await _firestore.collection('donationRequests').doc(requestId).update({
        'status': 'accepted',
      });
    } catch (e) {
      print("❌ Error accepting donation request: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentDonorInfo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance.collection('donors').doc(uid).get();
    return doc.data();
  }

  // ❌ Reject a donation request
  Future<void> rejectDonationRequest(String requestId) async {
    try {
      await _firestore.collection('donationRequests').doc(requestId).update({
        'status': 'rejected',
      });
    } catch (e) {
      print("❌ Error rejecting donation request: $e");
      rethrow;
    }
  }
}