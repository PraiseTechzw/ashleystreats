import '../../features/products/data/product_repository.dart';
import '../../features/products/data/models/product_isar.dart';

class DataSeedingService {
  static final DataSeedingService _instance = DataSeedingService._internal();
  factory DataSeedingService() => _instance;
  DataSeedingService._internal();

  final ProductRepository _productRepository = ProductRepository();

  Future<void> seedSampleData() async {
    try {
      // Check if data already exists
      final existingProducts = await _productRepository.getAllProducts();
      if (existingProducts.isNotEmpty) {
        print('Sample data already exists. Skipping seeding.');
        return;
      }

      print('Seeding sample data...');
      
      final sampleProducts = _getSampleProducts();
      
      for (final product in sampleProducts) {
        await _productRepository.addOrUpdateProduct(product);
      }
      
      print('Sample data seeded successfully. ${sampleProducts.length} products added.');
    } catch (e) {
      print('Error seeding sample data: $e');
    }
  }

  List<ProductIsar> _getSampleProducts() {
    final now = DateTime.now();
    
    return [
      // Cupcakes
      ProductIsar()
        ..productId = 'cup_001'
        ..name = 'Rainbow Cupcake'
        ..description = 'A colorful cupcake with rainbow sprinkles and vanilla buttercream frosting'
        ..category = 'Cupcakes'
        ..price = 4.50
        ..images = ['https://example.com/rainbow-cupcake.jpg']
        ..ingredients = ['Flour', 'Sugar', 'Eggs', 'Butter', 'Vanilla', 'Food Coloring', 'Sprinkles']
        ..availability = true
        ..stockQuantity = 24
        ..createdAt = now
        ..updatedAt = now,

      ProductIsar()
        ..productId = 'cup_002'
        ..name = 'Chocolate Delight Cupcake'
        ..description = 'Rich chocolate cupcake with chocolate ganache and chocolate chips'
        ..category = 'Cupcakes'
        ..price = 4.75
        ..images = ['https://example.com/chocolate-cupcake.jpg']
        ..ingredients = ['Flour', 'Cocoa Powder', 'Sugar', 'Eggs', 'Butter', 'Chocolate Chips']
        ..availability = true
        ..stockQuantity = 18
        ..createdAt = now
        ..updatedAt = now,

      ProductIsar()
        ..productId = 'cup_003'
        ..name = 'Strawberry Bliss Cupcake'
        ..description = 'Fresh strawberry cupcake with cream cheese frosting and strawberry pieces'
        ..category = 'Cupcakes'
        ..price = 4.25
        ..images = ['https://example.com/strawberry-cupcake.jpg']
        ..ingredients = ['Flour', 'Sugar', 'Eggs', 'Butter', 'Strawberries', 'Cream Cheese']
        ..availability = true
        ..stockQuantity = 20
        ..createdAt = now
        ..updatedAt = now,

      // Cake Slices
      ProductIsar()
        ..productId = 'slice_001'
        ..name = 'Red Velvet Cake Slice'
        ..description = 'Classic red velvet cake with cream cheese frosting'
        ..category = 'Cake Slices'
        ..price = 6.50
        ..images = ['https://example.com/red-velvet-slice.jpg']
        ..ingredients = ['Flour', 'Cocoa Powder', 'Sugar', 'Eggs', 'Buttermilk', 'Red Food Coloring']
        ..availability = true
        ..stockQuantity = 12
        ..createdAt = now
        ..updatedAt = now,

      ProductIsar()
        ..productId = 'slice_002'
        ..name = 'Lemon Drizzle Cake Slice'
        ..description = 'Moist lemon cake with tangy lemon glaze'
        ..category = 'Cake Slices'
        ..price = 5.75
        ..images = ['https://example.com/lemon-slice.jpg']
        ..ingredients = ['Flour', 'Sugar', 'Eggs', 'Butter', 'Lemons', 'Powdered Sugar']
        ..availability = true
        ..stockQuantity = 8
        ..createdAt = now
        ..updatedAt = now,

      // Cake Tasters
      ProductIsar()
        ..productId = 'taster_001'
        ..name = 'Mini Chocolate Cake Taster'
        ..description = 'Small portion chocolate cake perfect for tasting'
        ..category = 'Cake Tasters'
        ..price = 2.50
        ..images = ['https://example.com/mini-chocolate.jpg']
        ..ingredients = ['Flour', 'Cocoa Powder', 'Sugar', 'Eggs', 'Butter']
        ..availability = true
        ..stockQuantity = 30
        ..createdAt = now
        ..updatedAt = now,

      ProductIsar()
        ..productId = 'taster_002'
        ..name = 'Mini Vanilla Cake Taster'
        ..description = 'Small portion vanilla cake with light frosting'
        ..category = 'Cake Tasters'
        ..price = 2.25
        ..images = ['https://example.com/mini-vanilla.jpg']
        ..ingredients = ['Flour', 'Sugar', 'Eggs', 'Butter', 'Vanilla Extract']
        ..availability = true
        ..stockQuantity = 25
        ..createdAt = now
        ..updatedAt = now,

      // Cake Pops
      ProductIsar()
        ..productId = 'pop_001'
        ..name = 'Chocolate Cake Pops'
        ..description = 'Bite-sized chocolate cake on a stick, covered in chocolate coating'
        ..category = 'Cake Pops'
        ..price = 3.00
        ..images = ['https://example.com/chocolate-pops.jpg']
        ..ingredients = ['Cake Crumbs', 'Cream Cheese', 'Chocolate Coating', 'Sprinkles']
        ..availability = true
        ..stockQuantity = 40
        ..createdAt = now
        ..updatedAt = now,

      ProductIsar()
        ..productId = 'pop_002'
        ..name = 'Birthday Cake Pops'
        ..description = 'Festive cake pops with colorful sprinkles, perfect for celebrations'
        ..category = 'Cake Pops'
        ..price = 3.25
        ..images = ['https://example.com/birthday-pops.jpg']
        ..ingredients = ['Cake Crumbs', 'Cream Cheese', 'White Chocolate', 'Rainbow Sprinkles']
        ..availability = true
        ..stockQuantity = 35
        ..createdAt = now
        ..updatedAt = now,

      // Custom Cakes
      ProductIsar()
        ..productId = 'custom_001'
        ..name = 'Custom Birthday Cake (Small)'
        ..description = 'Personalized birthday cake for 6-8 people with custom decorations'
        ..category = 'Custom Cakes'
        ..price = 35.00
        ..images = ['https://example.com/custom-birthday-small.jpg']
        ..ingredients = ['Flour', 'Sugar', 'Eggs', 'Butter', 'Custom Decorations']
        ..availability = true
        ..stockQuantity = 5
        ..createdAt = now
        ..updatedAt = now,

      ProductIsar()
        ..productId = 'custom_002'
        ..name = 'Custom Wedding Cake (Medium)'
        ..description = 'Elegant wedding cake for 15-20 people with custom design'
        ..category = 'Custom Cakes'
        ..price = 85.00
        ..images = ['https://example.com/custom-wedding-medium.jpg']
        ..ingredients = ['Premium Flour', 'Sugar', 'Eggs', 'Butter', 'Fondant', 'Decorative Elements']
        ..availability = true
        ..stockQuantity = 2
        ..createdAt = now
        ..updatedAt = now,

      // Seasonal Specials
      ProductIsar()
        ..productId = 'seasonal_001'
        ..name = 'Halloween Spooky Cupcakes'
        ..description = 'Halloween-themed cupcakes with spooky decorations'
        ..category = 'Seasonal Specials'
        ..price = 5.00
        ..images = ['https://example.com/halloween-cupcakes.jpg']
        ..ingredients = ['Flour', 'Sugar', 'Eggs', 'Butter', 'Orange Food Coloring', 'Halloween Decorations']
        ..availability = false // Seasonal item
        ..stockQuantity = 0
        ..createdAt = now
        ..updatedAt = now,

      ProductIsar()
        ..productId = 'seasonal_002'
        ..name = 'Christmas Cookie Cake'
        ..description = 'Festive cookie cake decorated with Christmas themes'
        ..category = 'Seasonal Specials'
        ..price = 25.00
        ..images = ['https://example.com/christmas-cookie-cake.jpg']
        ..ingredients = ['Cookie Dough', 'Sugar', 'Butter', 'Christmas Icing', 'Holiday Sprinkles']
        ..availability = false // Seasonal item
        ..stockQuantity = 0
        ..createdAt = now
        ..updatedAt = now,
    ];
  }

  Future<void> clearAllData() async {
    try {
      final products = await _productRepository.getAllProducts();
      for (final product in products) {
        await _productRepository.deleteProduct(product.id);
      }
      print('All sample data cleared.');
    } catch (e) {
      print('Error clearing sample data: $e');
    }
  }

  Future<void> reseedData() async {
    await clearAllData();
    await seedSampleData();
  }
}