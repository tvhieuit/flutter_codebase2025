import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';

part 'create_product_use_case.freezed.dart';

/// Parameters for creating a new product.
@paramsFreezed
sealed class CreateProductParams with _$CreateProductParams {
  const factory CreateProductParams({
    required String name,
    required String description,
    required int priceInCents,
    required String category,
    String? imageUrl,
    required int stockQuantity,
  }) = _CreateProductParams;
}

/// Use case for creating a new product.
@injectable
class CreateProductUseCase implements UseCaseWithParams<ProductEntity, CreateProductParams> {
  final ProductRepository _repository;

  CreateProductUseCase(this._repository);

  @override
  Future<Result<ProductEntity>> call(CreateProductParams params) async {
    if (params.name.trim().isEmpty) {
      return Result.failure(Failure.required('Product name'));
    }

    if (params.description.trim().isEmpty) {
      return Result.failure(Failure.required('Description'));
    }

    if (params.priceInCents <= 0) {
      return const Result.failure(
        Failure.validation(
          message: 'Price must be greater than 0',
          code: 'INVALID_PRICE',
        ),
      );
    }

    if (params.category.trim().isEmpty) {
      return Result.failure(Failure.required('Category'));
    }

    if (params.stockQuantity < 0) {
      return const Result.failure(
        Failure.validation(
          message: 'Stock quantity cannot be negative',
          code: 'INVALID_STOCK',
        ),
      );
    }

    return await _repository.createProduct(
      name: params.name.trim(),
      description: params.description.trim(),
      priceInCents: params.priceInCents,
      category: params.category.trim(),
      imageUrl: params.imageUrl,
      stockQuantity: params.stockQuantity,
    );
  }
}
