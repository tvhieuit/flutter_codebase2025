import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';

import 'package:domain/domain.dart';
import '../base_use_case.dart';

/// Use case for clearing all user data from local storage.
@injectable
class ClearUserDataUseCase implements UseCase<void> {
  final UserLocalRepository _userLocalRepository;

  ClearUserDataUseCase(this._userLocalRepository);

  @override
  Future<Result<void>> call() async {
    return await _userLocalRepository.clearAllUserData();
  }
}
