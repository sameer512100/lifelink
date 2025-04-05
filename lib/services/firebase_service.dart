import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/donation_request.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream all donation requests
  Stream<List<DonationRequest>> fetchDonationRequests() {
    return _firestore.collection('donationRequests').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DonationRequest.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Stream requests for a specific hospital
  Stream<List<DonationRequest>> getHospitalDonationRequests(String hospitalName) {
    return _firestore
        .collection('donationRequests')
        .where('hospitalName', isEqualTo: hospitalName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DonationRequest.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Add a new request
  Future<void> addDonationRequest(DonationRequest request) async {
    await _firestore.collection('donationRequests').doc(request.id).set(request.toMap());
  }

  // Accept request
  Future<void> acceptDonationRequest(String requestId) async {
    final donorInfo = await getCurrentDonorInfo();
    final donorName = donorInfo?['name'] ?? 'Unknown Donor';

    await _firestore.collection('donationRequests').doc(requestId).update({
      'status': 'accepted',
      'acceptedBy': donorName,
    });
  }

  // Reject request
  Future<void> rejectDonationRequest(String requestId) async {
    final donorInfo = await getCurrentDonorInfo();
    final donorName = donorInfo?['name'] ?? 'Unknown Donor';

    await _firestore.collection('donationRequests').doc(requestId).update({
      'status': 'rejected',
      'rejectedBy': donorName,
    });
  }

  // Get current donor info
  Future<Map<String, dynamic>?> getCurrentDonorInfo() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('donors').doc(uid).get();
    return doc.data();
  }
}
