import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import '../../entities/user_entity.dart';
import '../../repositories/local/user_local_repository.dart';
import '../base_use_case.dart';

/// Use case for getting cached users from local storage.
@injectable
class GetCachedUsersUseCase implements UseCase<List<UserEntity>> {
  final UserLocalRepository _userLocalRepository;

  GetCachedUsersUseCase(this._userLocalRepository);

  @override
  Future<Result<List<UserEntity>>> call() async {
    return await _userLocalRepository.getCachedUsers();
  }
}
