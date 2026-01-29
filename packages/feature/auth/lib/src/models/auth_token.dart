import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

/// Authentication token response
@modelFreezed
sealed class AuthToken with _$AuthToken {
  const AuthToken._();

  const factory AuthToken({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    @JsonKey(name: 'expires_in') int? expiresIn,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  /// Checks if token is expired (if expiresIn is available)
  bool get isExpired {
    if (expiresIn == null) return false;
    // Note: In real app, you'd compare with stored timestamp
    return false;
  }

  /// Gets the authorization header value
  String get authorizationHeader => '$tokenType $accessToken';
}
