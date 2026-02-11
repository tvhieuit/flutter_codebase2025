import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

/// Custom Freezed annotation for Events
/// - No copyWith (events are immutable and don't need copying)
/// - No equal (events are compared by identity)
/// - No JSON serialization
/// - No toString override
const eventFreezed = Freezed(
  copyWith: false,
  equal: false,
  fromJson: false,
  toJson: false,
  toStringOverride: false,
);

/// Custom Freezed annotation for States
/// - With copyWith (states need to be copied with modifications)
/// - No equal (states are compared by identity in BLoC)
/// - No JSON serialization
/// - No toString override
const stateFreezed = Freezed(
  copyWith: true,
  equal: false,
  fromJson: false,
  toJson: false,
  toStringOverride: false,
);

/// Custom Freezed annotation for Models/Entities
/// - No copyWith (use factory constructors)
/// - No equal (use identity comparison)
/// - With JSON serialization (for API responses)
/// - No toString override
const modelFreezed = Freezed(
  copyWith: false,
  equal: false,
  fromJson: true,
  toJson: true,
  toStringOverride: false,
);

/// Custom Freezed annotation for Result/Failure types
/// - With copyWith
/// - No equal
/// - No JSON serialization
/// - No toString override
const resultFreezed = Freezed(
  copyWith: false,
  equal: false,
  fromJson: false,
  toJson: false,
  toStringOverride: false,
);

/// Custom Freezed annotation for Use Case Params
/// - No copyWith
/// - No equal
/// - No JSON serialization
/// - No toString override
const paramsFreezed = Freezed(
  copyWith: false,
  equal: false,
  fromJson: false,
  toJson: false,
  toStringOverride: false,
);


const apiUrlNamed = Named('api_url_named');
const tenantIdNamed = Named('tenant_id_named');
const categoryOilNamed = Named('category_oil_named');
const authInterceptorNamed = Named('auth_interceptor_named');
const dioNamed = Named('dio_named');
const authDioNamed = Named('auth_dio_named');

