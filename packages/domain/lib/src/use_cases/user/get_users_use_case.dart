import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';
import '../base_use_case.dart';

part 'get_users_use_case.freezed.dart';

/// Parameters for getting users with pagination.
@paramsFreezed
sealed class GetUsersParams with _$GetUsersParams {
  const factory GetUsersParams({@Default(1) int page, @Default(20) int limit}) =
      _GetUsersParams;
}

/// Use case for getting a list of users with pagination.
///
/// Example usage:
/// ```dart
/// final result = await _getUsersUseCase(
///   const GetUsersParams(page: 1, limit: 20),
/// );
/// ```
class GetUsersUseCase
    implements UseCaseWithParams<List<UserEntity>, GetUsersParams> {
  final UserRepository _repository;

  GetUsersUseCase(this._repository);

  @override
  Future<Result<List<UserEntity>>> call(GetUsersParams params) async {
    // Validation
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

    final result = await _repository.getUsers(
      page: params.page,
      limit: params.limit,
    );
    return result;
  }
}

/// Parameters for searching users.
@paramsFreezed
sealed class SearchUsersParams with _$SearchUsersParams {
  const factory SearchUsersParams({required String query}) = _SearchUsersParams;
}

/// Use case for searching users.
class SearchUsersUseCase
    implements UseCaseWithParams<List<UserEntity>, SearchUsersParams> {
  final UserRepository _repository;

  SearchUsersUseCase(this._repository);

  @override
  Future<Result<List<UserEntity>>> call(SearchUsersParams params) async {
    // Validation
    if (params.query.trim().isEmpty) {
      return const Result.failure(
        Failure.validation(
          message: 'Search query cannot be empty',
          code: 'EMPTY_QUERY',
        ),
      );
    }

    if (params.query.length < 2) {
      return const Result.failure(
        Failure.validation(
          message: 'Search query must be at least 2 characters',
          code: 'QUERY_TOO_SHORT',
        ),
      );
    }

    final result = await _repository.searchUsers(params.query.trim());
    return result;
  }
}
