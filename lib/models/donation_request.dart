import 'package:cloud_firestore/cloud_firestore.dart';

class DonationRequest {
  final String id;
  final String hospitalName;
  final String bloodType;
  final String location;
  final String contact;
  final Timestamp timestamp;
  final String status;
  final String acceptedBy;
  final String rejectedBy;

  DonationRequest({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.location,
    required this.contact,
    required this.timestamp,
    this.status = 'pending',
    this.acceptedBy = '',
    this.rejectedBy = '',
  });

  /// ✅ Safely handles both Timestamp and ISO date String from Firestore
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

  /// ✅ Converts Firestore document data into DonationRequest object
  factory DonationRequest.fromMap(String id, Map<String, dynamic> data) {
    return DonationRequest(
      id: id,
      hospitalName: data['hospitalName']?.toString() ?? 'Unknown Hospital',
      bloodType: data['bloodType']?.toString() ?? 'Unknown',
      location: data['location']?.toString() ?? 'Unknown',
      contact: data['contact']?.toString() ?? 'N/A',
      timestamp: _parseTimestamp(data['timestamp']),
      status: data['status']?.toString() ?? 'pending',
      acceptedBy: data['acceptedBy']?.toString() ?? '',
      rejectedBy: data['rejectedBy']?.toString() ?? '',
    );
  }

  /// ✅ Upload-safe format for Firestore
  Map<String, dynamic> toMap() {
    return {
      'hospitalName': hospitalName,
      'bloodType': bloodType,
      'location': location,
      'contact': contact,
      'timestamp': timestamp,
      'status': status,
      'acceptedBy': acceptedBy,
      'rejectedBy': rejectedBy,
    };
  }

  /// 🔍 Optional: JSON format (useful for logs or HTTP requests)
  Map<String, dynamic> toJson() => toMap();
}
