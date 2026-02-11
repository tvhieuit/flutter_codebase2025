import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';

/// Use case for deleting a product.
@injectable
class DeleteProductUseCase implements UseCaseWithParams<void, int> {
  final ProductRepository _repository;

  DeleteProductUseCase(this._repository);

  @override
  Future<Result<void>> call(int productId) async {
    if (productId <= 0) {
      return const Result.failure(
        Failure.validation(
          message: 'Invalid product ID',
          code: 'INVALID_PRODUCT_ID',
        ),
      );
    }

    return await _repository.deleteProduct(productId);
  }
}
