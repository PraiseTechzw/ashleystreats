import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.productId,
    required super.name,
    required super.description,
    required super.category,
    required super.price,
    required super.images,
    required super.ingredients,
    required super.nutritionalInfo,
    required super.availability,
    required super.stockQuantity,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: _parsePrice(map['price']),
      images: List<String>.from(map['images'] ?? []),
      ingredients: List<String>.from(map['ingredients'] ?? []),
      nutritionalInfo: Map<String, dynamic>.from(map['nutritionalInfo'] ?? {}),
      availability: map['availability'] ?? true,
      stockQuantity: map['stockQuantity'] ?? 0,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'images': images,
      'ingredients': ingredients,
      'nutritionalInfo': nutritionalInfo,
      'availability': availability,
      'stockQuantity': stockQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
