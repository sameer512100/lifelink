class DonationRequest {
  final String id;
  final String hospitalName;
  final String bloodType;
  final String location;
  final String timestamp;

  DonationRequest({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.location,
    required this.timestamp,
  });

  factory DonationRequest.fromMap(String id, Map<dynamic, dynamic> data) {
    return DonationRequest(
      id: id,
      hospitalName: data['hospitalName'] ?? 'Unknown Hospital',
      bloodType: data['bloodType'] ?? 'Unknown',
      location: data['location'] ?? 'Unknown',
      timestamp: data['timestamp'] ?? '',
    );
  }
}
