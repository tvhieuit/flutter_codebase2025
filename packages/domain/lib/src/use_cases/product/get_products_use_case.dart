import 'package:freezed_annotation/freezed_annotation.dart';

import '../../annotations/annotations.dart';
import '../../entities/product_entity.dart';
import '../../failures/failure.dart';
import '../../repositories/product_repository.dart';
import '../../result/result.dart';
import '../base_use_case.dart';

part 'get_products_use_case.freezed.dart';

/// Parameters for getting products with filtering and pagination.
@paramsFreezed
sealed class GetProductsParams with _$GetProductsParams {
  const factory GetProductsParams({
    String? category,
    @Default(1) int page,
    @Default(20) int limit,
    @Default('createdAt') String sortBy,
    @Default(false) bool ascending,
  }) = _GetProductsParams;
}

/// Use case for getting products with filtering and pagination.
class GetProductsUseCase
    implements UseCaseWithParams<List<ProductEntity>, GetProductsParams> {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  static const _validSortFields = ['name', 'price', 'createdAt'];

  @override
  Future<Result<List<ProductEntity>>> call(GetProductsParams params) async {
    // Validate pagination
    if (params.page < 1) {
      return const Result.failure(
        Failure.validation(
          message: 'Page must be greater than 0',
          code: 'INVALID_PAGE',
        ),
      );
    }

    if (params.limit < 1 || params.limit > 100) {
      return const Result.failure(
        Failure.validation(
          message: 'Limit must be between 1 and 100',
          code: 'INVALID_LIMIT',
        ),
      );
    }

    // Validate sort field
    if (!_validSortFields.contains(params.sortBy)) {
      return Result.failure(
        Failure.validation(
          message: 'Sort field must be one of: ${_validSortFields.join(', ')}',
          code: 'INVALID_SORT_FIELD',
        ),
      );
    }

    return await _repository.getProducts(
      category: params.category,
      page: params.page,
      limit: params.limit,
      sortBy: params.sortBy,
      ascending: params.ascending,
    );
  }
}

/// Parameters for searching products.
@paramsFreezed
sealed class SearchProductsParams with _$SearchProductsParams {
  const factory SearchProductsParams({required String query}) =
      _SearchProductsParams;
}

/// Use case for searching products.
class SearchProductsUseCase
    implements UseCaseWithParams<List<ProductEntity>, SearchProductsParams> {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  @override
  Future<Result<List<ProductEntity>>> call(SearchProductsParams params) async {
    if (params.query.trim().isEmpty) {
      return const Result.failure(
        Failure.validation(
          message: 'Search query cannot be empty',
          code: 'EMPTY_QUERY',
        ),
      );
    }

    return await _repository.searchProducts(params.query.trim());
  }
}

/// Use case for getting products by category.
class GetProductsByCategoryUseCase
    implements UseCaseWithParams<List<ProductEntity>, String> {
  final ProductRepository _repository;

  GetProductsByCategoryUseCase(this._repository);

  @override
  Future<Result<List<ProductEntity>>> call(String category) async {
    if (category.trim().isEmpty) {
      return const Result.failure(
        Failure.validation(
          message: 'Category cannot be empty',
          code: 'EMPTY_CATEGORY',
        ),
      );
    }

    return await _repository.getProductsByCategory(category.trim());
  }
}
