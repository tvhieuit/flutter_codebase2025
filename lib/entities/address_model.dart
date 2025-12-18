import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const factory AddressModel({
    int? id,
    @JsonKey(name: 'address_name') String? name,
    @JsonKey(name: 'y') double? lat,
    @JsonKey(name: 'x') double? lng,
    String? address,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

