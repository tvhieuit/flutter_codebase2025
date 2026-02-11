import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';

/// Use case for refreshing the access token.
@injectable
class RefreshTokenUseCase implements UseCaseWithParams<AuthToken, String> {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  @override
  Future<Result<AuthToken>> call(String refreshToken) async {
    if (refreshToken.trim().isEmpty) {
      return const Result.failure(
        Failure.auth(message: 'Refresh token is empty', code: 'EMPTY_REFRESH_TOKEN'),
      );
    }

    return await _repository.refreshToken(refreshToken);
  }
}
