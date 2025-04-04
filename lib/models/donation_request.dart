class DonationRequest {
  final String id;
  final String hospitalName;
  final String bloodType;
  final String location;
  final int unitsNeeded;

  DonationRequest({
    required this.id,
    required this.hospitalName,
    required this.bloodType,
    required this.location,
    required this.unitsNeeded,
  });

  factory DonationRequest.fromMap(Map<dynamic, dynamic> data, String id) {
    return DonationRequest(
      id: id,
      hospitalName: data['hospitalName'] ?? '',
      bloodType: data['bloodType'] ?? '',
      location: data['location'] ?? '',
      unitsNeeded: data['unitsNeeded'] ?? 0,
    );
  }
}
