import 'package:injectable/injectable.dart';

import '../entities/address_model.dart';
import '../repository/remote_repository.dart';

abstract class AddressUseCase {
  Future<List<AddressModel>> getAddresses();
  Future<void> saveAddress(AddressModel address);
}

@Injectable(as: AddressUseCase)
class AddressUseCaseImpl implements AddressUseCase {
  final RemoteRepository _repository;

  AddressUseCaseImpl(this._repository);

  @override
  Future<List<AddressModel>> getAddresses() async {
    return await _repository.getAddresses();
  }

  @override
  Future<void> saveAddress(AddressModel address) async {
    await _repository.saveAddress(address);
  }
}

