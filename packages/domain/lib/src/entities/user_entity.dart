import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// User entity representing a user in the domain layer.
@modelFreezed
sealed class UserEntity with _$UserEntity {
  const UserEntity._();

  const factory UserEntity({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String email,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  /// Checks if the user has a valid email
  bool get hasValidEmail => email.contains('@') && email.contains('.');

  /// Checks if the user has complete profile
  bool get hasCompleteProfile => name.isNotEmpty && email.isNotEmpty && phone != null;

  /// Checks if this is an empty/default user
  bool get isEmpty => id == 0 && name.isEmpty && email.isEmpty;
}
