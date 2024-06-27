import 'dart:convert';

class ProductEntity {
  final String brand;
  final String name;
  final String type;
  final String country;
  final List<String> afterUse;

  ProductEntity({
    required this.brand,
    required this.name,
    required this.type,
    required this.country,
    required this.afterUse,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      brand: json['brand'] ?? 'Unknown',
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      country: json['country'] ?? 'Unknown',
      afterUse: json['afterUse'] != null
          ? List<String>.from(jsonDecode(json['afterUse']))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'name': name,
      'type': type,
      'country': country,
      'afterUse': jsonEncode(afterUse),
    };
  }
}
