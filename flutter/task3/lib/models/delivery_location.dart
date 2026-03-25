class DeliveryLocation {
  final int id;
  final String name;
  final String address;
  final double lat;
  final double lng;

  const DeliveryLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      id: json['id'] as int,
      name: json['name'] as String,
      address:
          '${json['street']}, ${json['city']}, ${json['state']} – ${json['pincode']}',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }
}
