import 'package:injectable/injectable.dart';

import 'package:dartz/dartz.dart';

import '../entities/user_model.dart';
import '../repository/remote_repository.dart';
import '../repository/local_repository.dart';
import '../utils/app_error.dart';

abstract class AuthUseCase {
  Future<Either<AppError, UserModel>> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

@Injectable(as: AuthUseCase)
class AuthUseCaseImpl implements AuthUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  AuthUseCaseImpl(
    this._remoteRepository,
    this._localRepository,
  );

  @override
  Future<Either<AppError, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return left(
          const AppError.validation('Email and password required'),
        );
      }

      // Simulated login - replace with actual API call
      final user = await _remoteRepository.getUserProfile();
      await _localRepository.saveUserToken('sample_token');

      return right(user);
    } catch (e) {
      return left(AppError.unknown(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await _localRepository.clearUserData();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = await _localRepository.getUserToken();
    if (token == null) {
      return null;
    }
    return await _remoteRepository.getUserProfile();
  }
}

