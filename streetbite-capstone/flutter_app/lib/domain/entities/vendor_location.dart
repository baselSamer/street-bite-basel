class VendorLocation {
  final String id;
  final String nameKey;
  final String cuisineKey;
  final double rating;
  final double latitude;
  final double longitude;

  const VendorLocation({
    required this.id,
    required this.nameKey,
    required this.cuisineKey,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });
}
