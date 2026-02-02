import '../../entities/product_entity.dart';
import 'package:app_core/app_core.dart';
import '../../repositories/product_repository.dart';
import '../base_use_case.dart';

/// Use case for getting a product by ID.
class GetProductUseCase implements UseCaseWithParams<ProductEntity, int> {
  final ProductRepository _repository;

  GetProductUseCase(this._repository);

  @override
  Future<Result<ProductEntity>> call(int productId) async {
    if (productId <= 0) {
      return const Result.failure(
        Failure.validation(
          message: 'Invalid product ID',
          code: 'INVALID_PRODUCT_ID',
        ),
      );
    }

    return await _repository.getProductById(productId);
  }
}

/// Use case for getting featured products.
class GetFeaturedProductsUseCase implements UseCase<List<ProductEntity>> {
  final ProductRepository _repository;
  final int limit;

  GetFeaturedProductsUseCase(this._repository, {this.limit = 10});

  @override
  Future<Result<List<ProductEntity>>> call() async {
    return await _repository.getFeaturedProducts(limit: limit);
  }
}
