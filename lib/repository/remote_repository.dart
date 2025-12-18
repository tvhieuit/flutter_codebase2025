import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../entities/user_model.dart';
import '../entities/address_model.dart';

abstract class RemoteRepository {
  Future<UserModel> getUserProfile();
  Future<List<AddressModel>> getAddresses();
  Future<void> saveAddress(AddressModel address);
}

@Injectable(as: RemoteRepository)
class RemoteRepositoryImpl implements RemoteRepository {
  final Dio _dio;

  RemoteRepositoryImpl(this._dio);

  @override
  Future<UserModel> getUserProfile() async {
    final response = await _dio.get('/user/profile');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await _dio.get('/addresses');
    final List<dynamic> data = response.data;
    return data.map((json) => AddressModel.fromJson(json)).toList();
  }

  @override
  Future<void> saveAddress(AddressModel address) async {
    await _dio.post('/addresses', data: address.toJson());
  }
}

