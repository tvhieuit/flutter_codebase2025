import '../entities/product_entity.dart';
import '../result/result.dart';

/// Product repository interface.
///
/// Defines the contract for product data access operations.
abstract class ProductRepository {
  /// Gets a product by its ID.
  Future<Result<ProductEntity>> getProductById(int id);

  /// Gets all products with optional filtering and pagination.
  Future<Result<List<ProductEntity>>> getProducts({
    String? category,
    int page = 1,
    int limit = 20,
    String sortBy = 'createdAt',
    bool ascending = false,
  });

  /// Gets products by category.
  Future<Result<List<ProductEntity>>> getProductsByCategory(String category);

  /// Searches products by query string.
  Future<Result<List<ProductEntity>>> searchProducts(String query);

  /// Gets featured/popular products.
  Future<Result<List<ProductEntity>>> getFeaturedProducts({int limit = 10});

  /// Gets all available categories.
  Future<Result<List<String>>> getCategories();

  /// Creates a new product (admin only).
  Future<Result<ProductEntity>> createProduct({
    required String name,
    required String description,
    required int priceInCents,
    required String category,
    String? imageUrl,
    required int stockQuantity,
  });

  /// Updates an existing product (admin only).
  Future<Result<ProductEntity>> updateProduct({
    required int id,
    String? name,
    String? description,
    int? priceInCents,
    String? category,
    String? imageUrl,
    int? stockQuantity,
    bool? isAvailable,
  });

  /// Deletes a product (admin only).
  Future<Result<void>> deleteProduct(int id);

  /// Updates product stock quantity.
  Future<Result<ProductEntity>> updateStock({
    required int id,
    required int quantity,
  });
}
