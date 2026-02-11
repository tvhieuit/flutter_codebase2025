import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';

/// Use case for getting the current logged-in user from local cache.
@injectable
class GetCurrentUserUseCase implements UseCase<UserEntity?> {
  final UserLocalRepository _userLocalRepository;

  GetCurrentUserUseCase(this._userLocalRepository);

  @override
  Future<Result<UserEntity?>> call() async {
    return await _userLocalRepository.getCurrentUser();
  }
}
