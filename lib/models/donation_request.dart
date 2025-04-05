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
  final double latitude;   // ✅ New
  final double longitude;  // ✅ New
  final String hospitalId;  // New field for hospital ID
  final Timestamp createdAt;  // New field for creation time

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
    this.latitude = 0.0,    // ✅ default to 0.0
    this.longitude = 0.0,
    required this.hospitalId,  // Hospital ID
    required this.createdAt,   // CreatedAt timestamp
  });

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
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      hospitalId: data['hospitalId']?.toString() ?? 'Unknown',
      createdAt: _parseTimestamp(data['createdAt']),
    );
  }

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
      'latitude': latitude,     // ✅ Include in Firestore
      'longitude': longitude,
      'hospitalId': hospitalId,  // Hospital ID
      'createdAt': createdAt,   // CreatedAt timestamp
    };
  }

  Map<String, dynamic> toJson() => toMap();
}
