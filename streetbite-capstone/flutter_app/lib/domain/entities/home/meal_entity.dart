class MealEntity {
  static const double samplePriceEgp = 100;

  final String id;
  final String name;
  final String category;
  final String area;
  final String thumbnailUrl;
  final double priceEgp;
  final String? instructions;

  const MealEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.thumbnailUrl,
    this.priceEgp = samplePriceEgp,
    this.instructions,
  });

  factory MealEntity.fromJson(Map<String, dynamic> json) => MealEntity(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String? ?? '',
    area: json['area'] as String? ?? '',
    thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
    priceEgp: (json['priceEgp'] as num?)?.toDouble() ?? samplePriceEgp,
    instructions: json['instructions'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'area': area,
    'thumbnailUrl': thumbnailUrl,
    'priceEgp': priceEgp,
    'instructions': instructions,
  };
}
