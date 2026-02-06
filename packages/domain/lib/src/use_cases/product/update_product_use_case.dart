import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../entities/product_entity.dart';
import '../../repositories/product_repository.dart';
import '../base_use_case.dart';

part 'update_product_use_case.freezed.dart';

/// Parameters for updating a product.
@paramsFreezed
sealed class UpdateProductParams with _$UpdateProductParams {
  const UpdateProductParams._();

  const factory UpdateProductParams({
    required int id,
    String? name,
    String? description,
    int? priceInCents,
    String? category,
    String? imageUrl,
    int? stockQuantity,
    bool? isAvailable,
  }) = _UpdateProductParams;

  /// Returns true if at least one field is being updated.
  bool get hasUpdates =>
      name != null ||
      description != null ||
      priceInCents != null ||
      category != null ||
      imageUrl != null ||
      stockQuantity != null ||
      isAvailable != null;
}

/// Use case for updating an existing product.
@injectable
class UpdateProductUseCase implements UseCaseWithParams<ProductEntity, UpdateProductParams> {
  final ProductRepository _repository;

  UpdateProductUseCase(this._repository);

  @override
  Future<Result<ProductEntity>> call(UpdateProductParams params) async {
    if (params.id <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Invalid product ID', code: 'INVALID_PRODUCT_ID'),
      );
    }

    if (!params.hasUpdates) {
      return const Result.failure(
        Failure.validation(message: 'No fields to update', code: 'NO_UPDATES'),
      );
    }

    if (params.priceInCents != null && params.priceInCents! <= 0) {
      return const Result.failure(
        Failure.validation(message: 'Price must be greater than 0', code: 'INVALID_PRICE'),
      );
    }

    if (params.stockQuantity != null && params.stockQuantity! < 0) {
      return const Result.failure(
        Failure.validation(
          message: 'Stock quantity cannot be negative',
          code: 'INVALID_STOCK',
        ),
      );
    }

    return await _repository.updateProduct(
      id: params.id,
      name: params.name?.trim(),
      description: params.description?.trim(),
      priceInCents: params.priceInCents,
      category: params.category?.trim(),
      imageUrl: params.imageUrl,
      stockQuantity: params.stockQuantity,
      isAvailable: params.isAvailable,
    );
  }
}
