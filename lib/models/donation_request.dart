import 'package:cloud_firestore/cloud_firestore.dart';

class DonationRequest {
  final String id;
  final String hospitalName;
  final String bloodType;
  final String location;
  final String contact;
  final Timestamp timestamp;

  DonationRequest({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.location,
    required this.contact,
    required this.timestamp,
  });

  // ✅ From Firestore (null-safe)
  factory DonationRequest.fromMap(String id, Map<String, dynamic> data) {
    return DonationRequest(
      id: id,
      hospitalName: data['hospitalName']?.toString() ?? 'Unknown Hospital',
      bloodType: data['bloodType']?.toString() ?? 'Unknown',
      location: data['location']?.toString() ?? 'Unknown',
      contact: data['contact']?.toString() ?? 'N/A',
      timestamp: _parseTimestamp(data['timestamp']),
    );
  }

  // ✅ Handle different timestamp formats
  static Timestamp _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value;
    if (value is String) {
      try {
        return Timestamp.fromDate(DateTime.parse(value));
      } catch (e) {
        print("❌ Invalid timestamp format: $value");
        return Timestamp.now();
      }
    }
    return Timestamp.now();
  }

  // 🔄 To Firestore
  Map<String, dynamic> toMap() {
    return {
      'hospitalName': hospitalName,
      'bloodType': bloodType,
      'location': location,
      'contact': contact,
      'timestamp': timestamp,
    };
  }
}
