class LocationRecord {
  final String blockName;
  final String blockLabel;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime recordedAt;

  LocationRecord({
    required this.blockName,
    required this.blockLabel,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });
}
