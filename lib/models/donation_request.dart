class DonationRequest {
  final String id;
  final String hospitalName;
  final String bloodType;
  final String location;
  final String contact;
  final String timestamp;

  DonationRequest({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.location,
    required this.contact,
    required this.timestamp,
  });

  factory DonationRequest.fromMap(String id, Map<dynamic, dynamic> data) {
    return DonationRequest(
      id: id,
      hospitalName: data['hospitalName'] ?? 'Unknown Hospital',
      bloodType: data['bloodType'] ?? 'Unknown',
      location: data['location'] ?? 'Unknown',
      contact: data['contact'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }

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
