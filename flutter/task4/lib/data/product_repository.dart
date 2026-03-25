import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts(int page, int limit) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate API

    return List.generate(limit, (index) {
      final actualIndex = (page - 1) * limit + index;

      return Product(
        title: "Product $actualIndex",
        price: actualIndex * 10.0,
      );
    });
  }
}