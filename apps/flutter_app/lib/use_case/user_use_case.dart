import 'package:injectable/injectable.dart';

import '../entities/user_model.dart';
import '../repository/local_repository.dart';
import '../repository/remote_repository.dart';

/// User use case interface for business logic
abstract class UserUseCase {
  Future<UserModel> getUserProfile(int userId);
  Future<List<UserModel>> getUsers({bool forceRefresh = false});
  Future<UserModel> updateUserProfile(int userId, Map<String, dynamic> data);
  Future<void> deleteUser(int userId);
  Future<UserModel?> getCachedUser();
  Future<void> logout();
}

/// Implementation of user use case
@Injectable(as: UserUseCase)
class UserUseCaseImpl implements UserUseCase {
  final RemoteRepository _remoteRepository;
  final LocalRepository _localRepository;

  UserUseCaseImpl(
    this._remoteRepository,
    this._localRepository,
  );

  @override
  Future<UserModel> getUserProfile(int userId) async {
    // Fetch from API
    final user = await _remoteRepository.getUserProfile(userId);

    // Cache locally
    await _localRepository.saveUser(user);

    return user;
  }

  @override
  Future<List<UserModel>> getUsers({bool forceRefresh = false}) async {
    // Try to get from cache first
    if (!forceRefresh) {
      final cachedUsers = await _localRepository.getUserList();
      if (cachedUsers.isNotEmpty) {
        return cachedUsers;
      }
    }

    // Fetch from API
    final users = await _remoteRepository.getUsers();

    // Cache locally
    await _localRepository.saveUserList(users);

    return users;
  }

  @override
  Future<UserModel> updateUserProfile(int userId, Map<String, dynamic> data) async {
    // Validate data
    if (data['name']?.toString().isEmpty ?? true) {
      throw Exception('Name is required');
    }

    if (data['email']?.toString().isEmpty ?? true) {
      throw Exception('Email is required');
    }

    // Update via API
    final updatedUser = await _remoteRepository.updateUserProfile(userId, data);

    // Update cache
    await _localRepository.saveUser(updatedUser);

    return updatedUser;
  }

  @override
  Future<void> deleteUser(int userId) async {
    // Delete via API
    await _remoteRepository.deleteUser(userId);

    // Clear cache
    await _localRepository.clearUser();
  }

  @override
  Future<UserModel?> getCachedUser() async {
    return await _localRepository.getUser();
  }

  @override
  Future<void> logout() async {
    // Clear all local data
    await _localRepository.clearUser();
    await _localRepository.clearToken();
  }
}
