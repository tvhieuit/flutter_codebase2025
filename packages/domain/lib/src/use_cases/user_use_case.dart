import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

/// User use case interface for business logic
abstract class UserUseCase {
  Future<UserEntity> getUserProfile(int userId);
  Future<List<UserEntity>> getUsers({bool forceRefresh = false});
  Future<UserEntity> updateUserProfile(int userId, Map<String, dynamic> data);
  Future<void> deleteUser(int userId);
  Future<UserEntity?> getCachedUser();
  Future<void> logout();
}

/// Implementation of user use case
@Injectable(as: UserUseCase)
class UserUseCaseImpl implements UserUseCase {
  final UserRepository _userRepository;

  UserUseCaseImpl(this._userRepository);

  @override
  Future<UserEntity> getUserProfile(int userId) async {
    final result = await _userRepository.getUserById(userId);
    return _unwrapResult(result);
  }

  @override
  Future<List<UserEntity>> getUsers({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedResult = await _userRepository.getCachedUserList();
      if (cachedResult is ResultSuccess<List<UserEntity>> && cachedResult.data.isNotEmpty) {
        return cachedResult.data;
      }
    }

    final result = await _userRepository.getUsers();
    return _unwrapResult(result);
  }

  @override
  Future<UserEntity> updateUserProfile(
    int userId,
    Map<String, dynamic> data,
  ) async {
    if (data['name']?.toString().isEmpty ?? true) {
      throw Exception('Name is required');
    }

    if (data['email']?.toString().isEmpty ?? true) {
      throw Exception('Email is required');
    }

    final result = await _userRepository.updateUser(
      id: userId,
      name: data['name'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
    );
    return _unwrapResult(result);
  }

  @override
  Future<void> deleteUser(int userId) async {
    final result = await _userRepository.deleteUser(userId);
    return _unwrapResult(result);
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final result = await _userRepository.getCachedUser();
    if (result is ResultSuccess<UserEntity?>) {
      return result.data;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _userRepository.clearCachedUser();
  }

  T _unwrapResult<T>(Result<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
