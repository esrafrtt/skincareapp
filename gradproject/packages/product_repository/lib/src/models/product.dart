import '../../product_repository.dart';

class Product {
  final String brand;
  final String name;
  final String type;
  final String country;
  final List<String> afterUse;

  Product({
    required this.brand,
    required this.name,
    required this.type,
    required this.country,
    required this.afterUse,
  });

  factory Product.fromEntity(ProductEntity entity) {
    return Product(
      brand: entity.brand,
      name: entity.name,
      type: entity.type,
      country: entity.country,
      afterUse: entity.afterUse,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      brand: brand,
      name: name,
      type: type,
      country: country,
      afterUse: afterUse,
    );
  }
}
